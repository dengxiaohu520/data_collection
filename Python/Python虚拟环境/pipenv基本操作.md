# pipenv基本操作
1.pipenv安装
```
$pip install pipenv
```
1. 在指定目录下创建虚拟环境, 会使用本地默认版本的python
```
$ pipenv install
```
2. 如果要指定版本创建环境，可以使用如下命令，当然前提是本地启动目录能找到该版本的python
```
$ pipenv --python 3.6
```
3. 激活虚拟环境
```
$ pipenv shell
```
4 安装第三方模块, 运行后会生成Pipfile和Pipfile.lock文件
```
$ pipenv install flask==0.12.1
```
5. 当然也可以不指定版本：
```
$ pipenv install numpy
```
6. 如果想只安装在开发环境才使用的包，这么做：
```
$ pipenv install pytest --dev
```
7. 无论是生产环境还是开发环境的包都会写入一个Pipfile里面，而如果是用传统方法，需要2个文件：dev-requirements.txt 和 test-requirements.txt。
接下来如果在开发环境已经完成开发，如何构建生产环境的东东呢？这时候就要使用Pipfile.lock了，运行以下命令，把当前环境的模块lock住, 它会更新Pipfile.lock文件，该文件是用于生产环境的，你永远不应该编辑它。
```
$ pipenv lock     
```
然后只需要把代码和Pipfile.lock放到生产环境，运行下面的代码，就可以创建和开发环境一样的环境咯，Pipfile.lock里记录了所有包和子依赖包的确切版本，因此是确定构建：
```
$ pipenv install --ignore-pipfile
```
如果要在另一个开发环境做开发，则将代码和Pipfile复制过去，运行以下命令：
```
$ pipenv install --dev
```
由于Pipfile里面没有所有子依赖包或者确定的版本，因此该安装可能会更新未指定模块的版本号，这不仅不是问题，还解决了一些其他问题，我在这里做一下解释：
假如该命令更新了一些依赖包的版本，由于我肯定还会在新环境做单元测试或者功能测试，因此我可以确保这些包的版本更新是不会影响软件功能的；然后我会pipenv lock并把它发布到生产环境，因此我可以确定生产环境也是不会有问题的。这样一来，我既可以保证生产环境和开发环境的一致性，又可以不用管理众多依赖包的版本，完美的解决方案！pipenv依赖分析详解
pipenv每次安装核心包时，都会检测所有核心包的子依赖包，对不满足的子依赖包会做更新。如果核心包package_a和package_b依赖有矛盾，比如(package_a依赖package_c>2.0, package_b依赖package_c<1.9），则会有警告提示。

8. 使用以下命令可以查看依赖关系：
```
$ pipenv graph
```
举个栗子：
```
Flask==0.12.1
- click [required: >=2.0, installed: 6.7]
- itsdangerous [required: >=0.21, installed: 0.24]
- Jinja2 [required: >=2.4, installed: 2.10]
- MarkupSafe [required: >=0.23, installed: 1.0]
- Werkzeug [required: >=0.7, installed: 0.14.1]
numpy==1.14.1
pytest==3.4.1
- attrs [required: >=17.2.0, installed: 17.4.0]
- funcsigs [required: Any, installed: 1.0.2]
- pluggy [required: <0.7,>=0.5, installed: 0.6.0]
- py [required: >=1.5.0, installed: 1.5.2]
- setuptools [required: Any, installed: 38.5.1]
- six [required: >=1.10.0, installed: 1.11.0]
requests==2.18.4
- certifi [required: >=2017.4.17, installed: 2018.1.18]
- chardet [required: >=3.0.2,<3.1.0, installed: 3.0.4]
- idna [required: >=2.5,<2.7, installed: 2.6]
- urllib3 [required: <1.23,>=1.21.1, installed: 1.22]Pipfile
```
举个栗子，它是 TOML 格式的：
```
[[source]]
url = "https://pypi.python.org/simple"
verify_ssl = true
name = "pypi"

[dev-packages]
pytest = "*"
[packages]
flask = "==0.12.1"
numpy = "*"
requests = {git = "https://github.com/requests/requests.git", editable = true}

[requires]
python_version = "3.6"
```
我不用管子依赖包，只会把我项目中实际用到的包放进去，子依赖包在pipenv install package的时候自动安装或更新。Pipfile.lock
举个栗子，它是JSON格式的，它包含了所有子依赖包的确定版本：
```
{
"_meta": {
...
},
"default": {
"flask": {
"hashes": [
"sha256:6c3130c8927109a08225993e4e503de4ac4f2678678ae211b33b519c622a7242",
"sha256:9dce4b6bfbb5b062181d3f7da8f727ff70c1156cbb4024351eafd426deb5fb88"
],
"version": "==0.12.1"
},
"requests": {
"editable": true,
"git": "https://github.com/requests/requests.git",
"ref": "4ea09e49f7d518d365e7c6f7ff6ed9ca70d6ec2e"
},
"werkzeug": {
"hashes": [
"sha256:d5da73735293558eb1651ee2fddc4d0dedcfa06538b8813a2e20011583c9e49b",
"sha256:c3fd7a7d41976d9f44db327260e263132466836cef6f91512889ed60ad26557c"
],
"version": "==0.14.1"
}
...
},
"develop": {
"pytest": {
"hashes": [
"sha256:8970e25181e15ab14ae895599a0a0e0ade7d1f1c4c8ca1072ce16f25526a184d",
"sha256:9ddcb879c8cc859d2540204b5399011f842e5e8823674bf429f70ada281b3cc6"
],
"version": "==3.4.1"
},
...
}
}
```
9. 卸载包
```
$ pipenv uninstall numpy
```
10. 当前虚拟环境目录
```
$ pipenv --venv
```
11. 当前项目根目录
```
$ pipenv --where旧项目的requirments.txt转化为Pipfile
```
使用pipenv install会自动检测当前目录下的requirments.txt, 并生成Pipfile, 我也可以再对生成的Pipfile做修改。
此外以下命令也有同样效果, 可以指定具体文件名：
```
$ pipenv install -r requirements.txt
```
如果我有一个开发环境的requirent-dev.txt, 可以用以下命令加入到Pipfile:
```
$ pipenv install -r dev-requirements.txt --dev
```

12. 查看虚拟环境路劲：
```
pipenv --venv
```





使用 pipenv 安装包时报错 pipenv.patched.notpip._internal.exceptions.InstallationError: Command “python setup.py egg_info” failed with error code 1 in …
这应该在虚拟环境之外运行：
pip install --user --upgrade --upgrade-strategy eager pipenv wheel
如果不行，先卸载 pipenv 再重新安装

pip uninstall pipenv
pip install pipenv



