# 目标

## 区分模型和关系
* 模型只存储自身属性
* 模型之间的关系存储在关系表中
* 一对一，一对多，多对多模型关系存储方式
  * 一对一：关系两边的id不能重复
  * 一对多：一端的id是不能重复，多端的id可以重复
  * 多对多：两端的id组合不能重复
## 路由、界面、接口生成
* 路由生成
  * 生成模型自身的增删改查界面路由
  * 生成模型API路由
  * 生成模型关系管理路由
* 界面生成
  * 生成模型自身的增删改查界面
    * 在模型列表显示中，显示模型模型关系链接
    * 在模型详细信息显示中，显示模型关系的链接
  * 生成模型关系管理界面
  * 生成模型自身的增删改查API
  * 生成模型关系的增删改查API