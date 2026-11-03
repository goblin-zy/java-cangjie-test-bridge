"""用members.json中的UTF-16位置和原方法体恢复源码，验证骨架对应关系。"""
from pathlib import Path
import argparse,json,hashlib

def reconstruct(metadata, file_info):
    folder=metadata.parent
    content=(folder/file_info['skeleton_file']).read_bytes().decode('utf-8').encode('utf-16-le')
    entries=[m for m in json.loads(metadata.read_text(encoding='utf-8'))['members'] if m.get('has_body') and m['source_location']['file']==file_info['original_file']]
    for m in sorted(entries,key=lambda x:x['skeleton_body_location']['start_offset_utf16'],reverse=True):
        loc=m['skeleton_body_location'];a=loc['start_offset_utf16']*2;b=loc['end_offset_utf16_exclusive']*2
        content=content[:a]+m['original_body'].encode('utf-16-le')+content[b:]
    result=content.decode('utf-16-le').encode('utf-8')
    if hashlib.sha256(result).hexdigest()!=file_info['source_sha256']:
        raise ValueError('Restored source differs: '+file_info['source_file'])
    return result

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('members_json',type=Path);parser.add_argument('output_directory',type=Path)
    args=parser.parse_args()
    if args.output_directory.exists() and any(args.output_directory.iterdir()):raise SystemExit('Output must be new or empty')
    data=json.loads(args.members_json.read_text(encoding='utf-8'))
    for f in data['files']:
        if f['status']!='extracted':continue
        result=reconstruct(args.members_json,f);target=args.output_directory/f['source_file'];target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(result)
    print('Restored sources match their original SHA-256 checksums.')
if __name__=='__main__':main()
