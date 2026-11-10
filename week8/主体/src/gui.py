"""Standard Tk desktop entry. Uses the same prepare() as the command line."""
from pathlib import Path
import json
import os
import queue
import subprocess
import sys
import threading
import traceback
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import preprocess
from desktop_workflow import check_environment, relative_root, validate_inputs, new_output, load_settings

ROOT = Path(__file__).resolve().parents[2]


def open_path(path):
    path = str(Path(path).resolve())
    if sys.platform == 'win32':
        os.startfile(path)
    elif sys.platform == 'darwin':
        subprocess.Popen(['open', path])
    else:
        subprocess.Popen(['xdg-open', path])


class App:
    def __init__(self, window):
        self.window = window
        window.title('测试代码预处理')
        width=min(1050,max(700,window.winfo_screenwidth()-80))
        height=min(820,max(550,window.winfo_screenheight()-100))
        window.geometry(f'{width}x{height}')
        window.minsize(min(850,width),min(650,height))
        window.protocol('WM_DELETE_WINDOW', self.close)
        self.events = queue.Queue()
        self.busy = False
        self.controls = []
        self.last_output = None
        self.project = tk.StringVar()
        self.parent = tk.StringVar(value=str(ROOT))
        self.java, self.javac = 'java', 'javac'
        self.status = tk.StringVar(value='先点“使用随包样例”，或选择自己的工程。')
        outer = ttk.Frame(window, padding=16)
        outer.pack(fill='both', expand=True)
        ttk.Label(outer, text='仅测试代码预处理', font=('Microsoft YaHei UI', 17, 'bold')).pack(anchor='w')
        ttk.Label(outer, text='保留测试与资源原文，生成结构索引和交接材料；不读取业务源码、不运行测试。').pack(anchor='w', pady=(4, 12))
        bar = ttk.Frame(outer);bar.pack(fill='x')
        self.button(bar, '使用随包样例', self.use_sample).pack(side='left')
        self.button(bar, '检查环境', self.environment).pack(side='left', padx=8)
        self.button(bar, '选择JDK', self.choose_jdk).pack(side='left')
        self.button(bar, '载入设置', self.load).pack(side='left', padx=8)
        self.button(bar, '保存设置', self.save).pack(side='left')
        ttk.Button(bar, text='使用说明', command=lambda:open_path(ROOT/'说明文档/使用说明.md')).pack(side='right')
        form = ttk.LabelFrame(outer, text='① 选择输入与保存位置', padding=10);form.pack(fill='x', pady=12)
        for i, (label, variable, callback) in enumerate([
            ('Java工程根目录',self.project,self.choose_project),('结果保存位置（自动新建轮次）',self.parent,self.choose_parent)]):
            ttk.Label(form,text=label).grid(row=i,column=0,sticky='w',padx=(0,8),pady=5)
            e=ttk.Entry(form,textvariable=variable);e.grid(row=i,column=1,sticky='ew');self.controls.append(e)
            self.button(form,'选择…',callback).grid(row=i,column=2,padx=(8,0))
        form.columnconfigure(1,weight=1)
        lists=ttk.Frame(outer);lists.pack(fill='x')
        self.tests=self.root_list(lists,'② 测试源码目录（含辅助类／基类）',False)
        self.resources=self.root_list(lists,'③ 测试资源目录（没有可留空）',True)
        ttk.Label(outer,text='标准目录会自动填入；多模块请逐个添加。这里不是选择单个@Test方法。').pack(anchor='w',pady=8)
        action=ttk.Frame(outer);action.pack(fill='x',pady=6)
        self.button(action,'开始预处理分析',self.start).pack(side='left')
        self.open_button=ttk.Button(action,text='打开本轮结果',command=self.open_result,state='disabled');self.open_button.pack(side='left',padx=8)
        self.report_button=ttk.Button(action,text='查看本轮说明',command=self.open_report,state='disabled');self.report_button.pack(side='left')
        self.activity=ttk.Frame(action)
        ttk.Label(self.activity,text='运行中').pack(side='left',padx=(10,6))
        self.progress=ttk.Progressbar(self.activity,mode='indeterminate',length=160)
        self.progress.pack(side='left')
        ttk.Label(outer,textvariable=self.status,wraplength=960).pack(anchor='w',pady=5)
        log_frame=ttk.LabelFrame(outer,text='运行信息（失败时请保留）',padding=5);log_frame.pack(fill='both',expand=True)
        self.log=tk.Text(log_frame,height=12,wrap='word',state='disabled');self.log.pack(side='left',fill='both',expand=True)
        scroll=ttk.Scrollbar(log_frame,command=self.log.yview);scroll.pack(side='right',fill='y');self.log.configure(yscrollcommand=scroll.set)
        window.after(100,self.poll)

    def button(self,parent,text,command):
        b=ttk.Button(parent,text=text,command=command);self.controls.append(b);return b

    def root_list(self,parent,title,resource):
        frame=ttk.LabelFrame(parent,text=title,padding=8);frame.pack(side='left',fill='both',expand=True,padx=(0,8))
        list_frame=ttk.Frame(frame);list_frame.pack(fill='both',expand=True)
        box=tk.Listbox(list_frame,height=5,exportselection=False);box.grid(row=0,column=0,sticky='nsew');self.controls.append(box)
        vertical=ttk.Scrollbar(list_frame,orient='vertical',command=box.yview);vertical.grid(row=0,column=1,sticky='ns')
        horizontal=ttk.Scrollbar(list_frame,orient='horizontal',command=box.xview);horizontal.grid(row=1,column=0,sticky='ew')
        box.configure(yscrollcommand=vertical.set,xscrollcommand=horizontal.set)
        list_frame.columnconfigure(0,weight=1);list_frame.rowconfigure(0,weight=1)
        bar=ttk.Frame(frame);bar.pack(fill='x',pady=(6,0))
        self.button(bar,'添加目录',lambda:self.add_root(box)).pack(side='left')
        self.button(bar,'移除选中',lambda:box.delete(*box.curselection()) if box.curselection() else None).pack(side='left',padx=8)
        return box

    def write(self,text):
        self.log.configure(state='normal');self.log.insert('end',text+'\n');self.log.see('end');self.log.configure(state='disabled')

    def fill_project(self,path):
        self.project.set(str(Path(path).resolve()))
        self.tests.delete(0,'end');self.resources.delete(0,'end')
        for rel, box in [('src/test/java',self.tests),('src/test/resources',self.resources)]:
            if (Path(path)/rel).is_dir():box.insert('end',rel)
        self.status.set('已选择工程。核对测试目录和结果保存位置，然后开始。')

    def use_sample(self):self.fill_project(ROOT/'样例/结果/input')
    def choose_project(self):
        path=filedialog.askdirectory(title='选择Java工程根目录（不是单个.java文件）')
        if path:self.fill_project(path)
    def choose_parent(self):
        path=filedialog.askdirectory(title='选择工程之外的结果保存位置')
        if path:self.parent.set(path)
    def add_root(self,box):
        try:
            if not self.project.get():raise ValueError('请先选择Java工程根目录。')
            path=filedialog.askdirectory(title='选择工程内部的测试／资源目录',initialdir=self.project.get())
            if path:
                rel=relative_root(self.project.get(),path)
                if rel not in box.get(0,'end'):box.insert('end',rel)
        except Exception as e:messagebox.showerror('目录需要调整',str(e))

    def choose_jdk(self):
        path=filedialog.askdirectory(title='选择完整JDK目录，内部应有bin/java和bin/javac')
        if not path:return
        suffix='.exe' if sys.platform=='win32' else ''
        java=Path(path)/'bin'/('java'+suffix);javac=Path(path)/'bin'/('javac'+suffix)
        if not java.is_file() or not javac.is_file():
            messagebox.showerror('不是完整JDK','请选择包含bin/java和bin/javac的JDK根目录。');return
        self.java,self.javac=str(java),str(javac)
        self.write('已选择JDK：'+path)

    def load(self):
        path=filedialog.askopenfilename(title='选择设置JSON',filetypes=[('JSON','*.json')])
        if not path:return
        try:
            cfg=load_settings(path)
            if cfg.get('project'):self.fill_project(cfg['project'])
            if cfg.get('output_parent'):self.parent.set(cfg['output_parent'])
            for name,box in [('test_roots',self.tests),('resource_roots',self.resources)]:
                if name in cfg:
                    box.delete(0,'end')
                    for x in cfg[name]:box.insert('end',x)
            self.java,self.javac=cfg.get('java','java'),cfg.get('javac','javac')
            self.write('设置已载入；请核对后开始。')
        except Exception as e:messagebox.showerror('设置无法载入',str(e))

    def save(self):
        path=filedialog.asksaveasfilename(title='保存本机设置（不建议提交个人路径）',defaultextension='.json',filetypes=[('JSON','*.json')])
        if path:
            try:
                Path(path).write_text(json.dumps({'project':str(Path(self.project.get()).resolve()) if self.project.get() else '', 'output_parent':str(Path(self.parent.get()).resolve()) if self.parent.get() else '', 'test_roots':list(self.tests.get(0,'end')),'resource_roots':list(self.resources.get(0,'end')),'java':self.java,'javac':self.javac},ensure_ascii=False,indent=2),encoding='utf-8')
                self.write('设置已保存。')
            except Exception as e:messagebox.showerror('保存失败',str(e))

    def set_busy(self,value):
        self.busy=value
        for widget in self.controls:widget.configure(state='disabled' if value else 'normal')
        if value:
            self.activity.pack(side='right',padx=10)
            self.progress.start(12)
        else:
            self.progress.stop()
            self.progress['value']=0
            self.activity.pack_forget()

    def environment(self):
        if self.busy:return
        java,javac=self.java,self.javac
        self.set_busy(True);self.status.set('正在检查Java/JDK环境…')
        def worker():
            try:self.events.put(('environment',check_environment(java,javac)))
            except Exception as e:self.events.put(('error',str(e)))
        threading.Thread(target=worker,daemon=True).start()

    def start(self):
        if self.busy:return
        try:
            if not self.project.get() or not self.parent.get():raise ValueError('请先选择工程和结果保存位置。')
            tests,resources=list(self.tests.get(0,'end')),list(self.resources.get(0,'end'))
            project,parent=validate_inputs(self.project.get(),self.parent.get(),tests,resources)
            output=new_output(parent)
        except Exception as e:messagebox.showerror('请先调整输入',str(e));return
        java,javac=self.java,self.javac
        self.last_output=output;self.open_button.configure(state='disabled');self.report_button.configure(state='disabled')
        self.log.configure(state='normal');self.log.delete('1.0','end');self.log.configure(state='disabled')
        self.set_busy(True);self.status.set('正在检查环境并分析，请勿重复点击…')
        self.write('输入：'+str(project));self.write('本轮结果：'+str(output))
        def worker():
            try:
                versions=check_environment(java,javac);self.events.put(('log',json.dumps(versions,ensure_ascii=False)))
                result=preprocess.prepare(project,output,tests,resources,java,javac)
                self.events.put(('done',result))
            except Exception as e:self.events.put(('failed',str(e)+'\n'+traceback.format_exc()))
        threading.Thread(target=worker,daemon=True).start()

    def poll(self):
        while True:
            try:kind,value=self.events.get_nowait()
            except queue.Empty:break
            if kind=='log':self.write(value);continue
            self.set_busy(False)
            if kind=='environment':self.status.set('环境检查通过。');self.write(json.dumps(value,ensure_ascii=False))
            elif kind=='done':
                self.status.set('分析已生成，状态：'+value['status']+'；不代表测试或译文验证通过。')
                self.write(self.status.get());self.write('请将整个结果目录交接，不只发一个JSON。')
            else:self.status.set('本轮未成功完成，请阅读下方原因。');self.write(value)
            if self.last_output and self.last_output.is_dir():self.open_button.configure(state='normal')
            if self.last_output and (self.last_output/'结果阅读说明.html').is_file():self.report_button.configure(state='normal')
            if self.last_output and kind in {'done','failed'}:
                try:
                    logfile=self.last_output.parent/(self.last_output.name+'.界面日志.txt')
                    logfile.write_text(self.log.get('1.0','end'),encoding='utf-8')
                except OSError:pass
        self.window.after(100,self.poll)

    def open_result(self):
        if self.last_output and self.last_output.exists():open_path(self.last_output)

    def open_report(self):
        if self.last_output and (self.last_output/'结果阅读说明.html').exists():open_path(self.last_output/'结果阅读说明.html')

    def close(self):
        if self.busy:
            messagebox.showinfo('正在处理','请等待当前分析结束后再关闭，避免留下未完成结果。');return
        self.window.destroy()


if __name__=='__main__':
    try:
        window=tk.Tk();App(window);window.mainloop()
    except Exception:
        import tempfile
        with tempfile.NamedTemporaryFile(prefix='test-only-gui-startup-',suffix='.log',mode='w',encoding='utf-8',delete=False) as log:
            log.write(traceback.format_exc());logfile=log.name
        if sys.platform=='win32':
            import ctypes
            ctypes.windll.user32.MessageBoxW(None,'窗口启动失败，请把此日志路径交给维护者：\n'+logfile,'预处理工具启动错误',0x10)
        else:
            print('Window startup failed. Log: '+logfile,file=sys.stderr)
