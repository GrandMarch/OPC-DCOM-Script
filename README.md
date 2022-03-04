## OPC-DCOM-Script
### 使用方法
1. 下载Dcom server.bat、Dcom client.bat以及DComPerm.exe，将下载的文件全部放在一个文件夹。
2. 以管理员身份打开CMD窗口，cd命令切换到保存下载文件的路径。
3. 根据需要选择运行Dcom server.bat还是Dcom client.bat
### 注意事项
Dcom server.bat 需要知道opc server的CLSID。CLSD可以通过如下方式找到：
windows+R快捷键打开运行对话框，然后输入dcomcnfg打开dcom配置窗口。通过左侧的导航窗口，定位到“DCOM配置”，然后找需要配置的opc server，接着在opc server上右键单击，选择“属性”。在“常规”标签页下即可看到CLSID。CLSID格式像这样：{434A6274-C539-4E99-88FC-44206D942775}
