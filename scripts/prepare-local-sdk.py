from pathlib import Path
import hashlib,json,shutil,struct

import argparse
parser=argparse.ArgumentParser(description="Prepare an isolated experimental fix for the exact official Windows 1.2.0 runtime.")
parser.add_argument('--source-sdk',required=True,help='SDK root containing envsetup.ps1')
parser.add_argument('--output-sdk',required=True,help='New directory; must not exist')
args=parser.parse_args()
src=Path(args.source_sdk).resolve()
dst=Path(args.output_sdk).resolve()
if dst.exists(): raise SystemExit('Output SDK already exists; refusing to overwrite')
if dst==src or src in dst.parents: raise SystemExit('Output must be outside the original SDK')
relative=Path('runtime/lib/windows_x86_64_cjnative/libcangjie-runtime.dll')
original=(src/relative).read_bytes()
expected='3cb25d76976fdd57a729e4734ae6ddc500dd9cd9d6ed06f373c01f127e6a91bb'
assert hashlib.sha256(original).hexdigest()==expected, 'Unexpected SDK runtime; refusing patch'
if not dst.exists(): shutil.copytree(src,dst)
data=bytearray(original)
pe=struct.unpack_from('<I',data,0x3c)[0]
nsections=struct.unpack_from('<H',data,pe+6)[0]
optional_size=struct.unpack_from('<H',data,pe+20)[0]
sections=pe+24+optional_size
def offset(rva):
    for i in range(nsections):
        pos=sections+i*40
        vs,va,rs,rp=struct.unpack_from('<IIII',data,pos+8)
        if va<=rva<va+max(vs,rs): return rp+rva-va
    raise ValueError(rva)

# 1. Keep the actual LIST_ENTRY sentinel, rather than its first data node.
p=offset(0x1d907)
assert data[p:p+4]==bytes.fromhex('4c8b6820')
data[p+1]=0x8d # MOV R13,[RAX+0x20] -> LEA R13,[RAX+0x20]
# 2. Start at advance-and-check, so neither an initial nor final sentinel is processed.
p2=offset(0x1d927)
assert data[p2:p2+16]==bytes.fromhex('4d89eceb110f1f40004d8b24244d39ec')
data[p2+4]=0x04 # initial JMP body -> JMP iterator=iterator->Flink; compare-to-head
(dst/relative).write_bytes(data)
assert (src/relative).read_bytes()==original
meta={
 'type':'local experimental binary correction; not an official SDK release',
 'base_sdk':'1.2.0 Windows x64','original_sha256':expected,
 'modified_sha256':hashlib.sha256(data).hexdigest(),
 'file':str(relative),'changes':[
 {'rva':'0x1d908','old':'8b','new':'8d','purpose':'retain loader list sentinel'},
 {'rva':'0x1d92b','old':'11','new':'04','purpose':'advance and check sentinel before reading module fields'}],
 'scope':'Only a new isolated output SDK. Original SDK and Windows DLLs unchanged.',
 'source_semantics':'head=&ppeb->Ldr->InMemoryOrderModuleList; for (iterator=head->Flink; iterator!=head; iterator=iterator->Flink) { existing body }',
 'warning':'Version string remains 1.2.0; modified runtime checksum and localfix label must accompany all experimental results.'}
(dst/'LOCAL-RUNTIME-FIX.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(dst)
print(json.dumps(meta,ensure_ascii=False,indent=2))
