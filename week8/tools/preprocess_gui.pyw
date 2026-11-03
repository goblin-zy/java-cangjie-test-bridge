"""本地窗口：选择仓库、生成材料包、可选导入Agent说明。"""
from pathlib import Path
import os
import threading
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import preprocess


def main():
    root = tk.Tk(); root.title("代码仓库预处理"); root.geometry("940x620")
    source, dest, java, javac = (tk.StringVar() for _ in range(4))
    java.set("java"); javac.set("javac")
    ttk.Label(root, text="输入整个代码库，不只选择src或单条测试。输出目录须在代码库外。", wraplength=740).pack(padx=15,pady=12)
    def row(label, var, chooser=None):
        f=ttk.Frame(root);f.pack(fill="x",padx=15,pady=4)
        ttk.Label(f,text=label,width=16).pack(side="left")
        ttk.Entry(f,textvariable=var).pack(side="left",fill="x",expand=True)
        if chooser:ttk.Button(f,text="选择",command=lambda:var.set(chooser() or var.get())).pack(side="right")
    row("代码库文件夹",source,filedialog.askdirectory)
    row("结果新文件夹",dest,lambda:filedialog.asksaveasfilename(title="填写一个尚不存在的文件夹名",initialfile="预处理结果-01"))
    row("java（保持默认）",java,filedialog.askopenfilename)
    row("javac（保持默认）",javac,filedialog.askopenfilename)
    ttk.Label(root,text="java运行结构解析器，javac编译结构解析器；找不到时选择同一JDK的bin目录内对应exe文件。",wraplength=890).pack(padx=15,pady=4)
    log=tk.Text(root,height=11,wrap="word");log.pack(fill="both",expand=True,padx=15,pady=10)
    log.insert("end","1. 选择完整代码库根目录，并填写代码库外的新结果目录。\n2. 点击开始预处理，完成后打开结果文件夹。程序不构建或运行输入工程。\n3. 需要Agent说明时，点击查看Agent任务，将任务和结果目录交给Agent。\n4. Agent生成agent-result.json后，再点击导入；该按钮不会自动调用Agent。\n5. 没有Agent说明也可将整个结果目录交给材料分类。\n")
    def say(text):log.insert("end",text+"\n");log.see("end")
    def run():
        if not source.get() or not dest.get():messagebox.showerror("路径未填写","请先选择输入与输出。");return
        button.config(state="disabled")
        values=(source.get(),dest.get(),java.get(),javac.get())
        def task():
            try:
                result=preprocess.prepare(*values)
                text=f"完成：{result['files']}个文件/目录条目，{result['symbols']}个结构条目。请打开结果查看issues和manifest；完成不代表全部解析成功。"
            except Exception as e:text="处理失败："+str(e)+"。已产生的中间文件保留；重试请换新结果目录。"
            root.after(0,lambda:(say(text),button.config(state="normal")))
        threading.Thread(target=task,daemon=True).start()
    def result_ready():
        if not dest.get() or not (Path(dest.get())/'handoff.json').is_file():
            messagebox.showinfo("请先完成预处理","请先生成结果，或将结果位置填写为已完成预处理的目录。");return False
        return True
    def open_task():
        if result_ready():os.startfile(str(Path(dest.get())/'给Agent的任务.txt'))
    def attach():
        if not result_ready():return
        if not messagebox.askokcancel("导入Agent说明","此功能导入已经生成的agent-result.json，不会自动调用Agent。\n\n若尚未生成，请取消并先查看Agent任务。不要选择空模板或其他JSON文件。"):
            return
        file=filedialog.askopenfilename(title="选择Agent已生成的agent-result.json",initialdir=dest.get(),filetypes=[("JSON","*.json")])
        if not file:return
        try:say("Agent说明检查结果："+str(preprocess.attach(dest.get(),file)))
        except Exception as e:messagebox.showerror("未能附加",str(e))
    buttons=ttk.Frame(root);buttons.pack(fill="x",padx=15,pady=10)
    button=ttk.Button(buttons,text="开始预处理",command=run);button.pack(side="left")
    ttk.Button(buttons,text="打开结果文件夹",command=lambda:os.startfile(dest.get()) if Path(dest.get()).is_dir() else messagebox.showinfo("提示","先完成预处理。")).pack(side="left",padx=8)
    ttk.Button(buttons,text="查看Agent任务",command=open_task).pack(side="left",padx=8)
    ttk.Button(buttons,text="导入Agent说明（可选）",command=attach).pack(side="left")
    root.mainloop()


if __name__ == "__main__":main()
