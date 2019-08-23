class CommonItem {
  final x,y;
  // CommonItem(){
  //   print('超类无参数构造');
  // }
  CommonItem.help({x, y}) 
  : assert(x > 0),
  x = x,
  y = y {
    print("超类命名构造函数");
  }
}

class CommonItemArrow extends CommonItem {
  CommonItemArrow(): super.help(x: 100, y: 100){
    print('子类无参数构造');
  }
  
  // CommonItemArrow.help(){
  //   x = 1;
  //   y = 61;
  //   print('子类命名构造函数');
  // }
}