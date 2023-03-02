# go基础语法
1. 基础语法表达
```
package main

import "fmt"

func main() {
	fmt.Println("hello, world")

}
```
2. const 用于声明一个常量

```
package main

import "fmt"
import "math"

const s string = "constant"

func main() {
	fmt.Ptintln(s)

}
```

3. for 循环
```
package main

import "fmt"

func main(){
	i := 1
	for i < 3 {
		fmt.Println(i)
		i = i +1
	}
	for {
		fmt.Pintln("loop")
		break
	}
}
```


