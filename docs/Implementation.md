系统实现报告
===

## 实现环境

### 数据库系统与前后端框架

* 数据库：SQLite3
* 前后端框架：Ruby On Rails - Rails 5.2.6
* 主要相关依赖版本：
  * Ruby - Ruby 2.7.4
  * Bootstrap - Bootstrap 4.0.0.alpha6

### 本地构建

```shell
$ bundle install
```

### 本地运行

```shell
$ rails db:migrate && rails s
```

随后访问 `localhost:3000` 端口即可。

## 系统功能结构图

<!-- TODO -->

## 基本表、主外码、索引

### 基本表

#### 账户 Account

| PK账户ID | STR用户名 | STR密码 | ENUM身份 | DEC余额 |
|--------|--------|-------|--------|-------|

* 身份是一个枚举类型，只能是 `Admin`、`Seller`、`Customer` 之一。

#### 买家 Customer

| PK买家ID | FK账户ID |
|--------|--------|

#### 卖家 Seller

| PK卖家ID | FK账户ID |
|--------|--------|

#### 管理员 Admin

| PK管理员ID | FK账户ID |
|---------|--------|

#### 投诉记录 Complaint

| PK投诉记录ID | FK买家ID | FK卖家ID | STR投诉内容 |
|----------|--------|--------|---------|

| PK投诉记录ID | PK管理员ID |
|----------|---------|

#### 店铺 Shop

| PK店铺ID | STR店铺名 | STR简介名 | FK卖家ID |
|--------|--------|--------|--------|

#### 商品类别 Category

| PK商品类别ID | STR类别名 |
|----------|--------|

#### 商品 Commodity

| PK商品ID | STR商品名 | STR商品简介 | DEC单价 | FK店铺ID |
|--------|--------|---------|-------|--------|

| PK商品ID | PK商品类别ID |
|--------|----------|

#### 订单 Order

| PK订单ID | INT数量 | DEC总价 | BOOL是否已结算 | FK商品ID | FK买家ID |
|--------|-------|-------|-----------|--------|--------|

#### 购买记录 Record

| PK购买记录ID | FK订单ID | FK评论组ID |
|----------|--------|---------|

#### 评论组 Section

| PK评论组ID | ENUM评分 |
|---------|--------|

* 评分是一个枚举类型，只能是 `1 ~ 5` 闭区间内的整数。

#### 评论 Comment

| PK评论ID | STR内容 | FK父级评论ID | FK账户ID | FK评论组ID |
|--------|-------|----------|--------|---------|

### 主外码

在上述表格中：
1. 若有且仅有一列 $c$ 被标注为 PK，则此表的主码就是 $c$；
2. 若有多于一列 $c_1,c_2,\dotsm,c_n(n\ge 2)$ 被标注为 PK，则此表的主码就是 $(c_1,c_2,\dotsm,c_n)$。

被标注为 FK 的是外码。

### 索引

对于一般情况，由于程序逻辑中经常需要且只需要查询外码，因此设计为：某一列有索引，当且仅当该列被标注为 FK。

## 安全性设计、权限管理

### 数据库与控制程序隔离

Rails 框架将控制程序与数据库解耦，因此控制程序并不会直接产生并调用 SQL 语句来操作数据库，而是通过 [OR Mapping](#rails-模型映射数据库实体or-mapping) 来间接操作数据库。因此安全性有一定的保障——可以防御诸如 SQL 注入的攻击。

### 前端展示与后端验证

#### 前端按用户角色展示

Rails 框架为前端渲染提供了 Embedded RuBy 视图渲染文件。在这些文件中可使用来自控制器的实例变量，内嵌 Ruby 代码来生成 HTML 文件，随后将 HTML 文件发送给前端，为用户提供 GUI 接口。

以 /app/views/accounts/statistic.html.erb 文件（初版，未加入 CSS/JS 等）为例：

```erb
<!-- /accounts/id/statistic ->
<h1>Sales Volume Statistic</h1>

<% if current_seller? %>
  <% current_account.seller.shops.each do |shop| %>
    <h3><%= shop.name %></h3>
    <% shop.commodities.each do |commodity| %>
      <p><%= commodity.name %>: <%= commodity.sales_volume %></p>
    <% end %>
  <% end %>
<% elsif current_admin? %>
  <% Shop.all.each do |shop| %>
    <h3><%= shop.name %> - (<%= shop.seller.account.name %>)</h3>
    <% shop.commodities.each do |commodity| %>
      <p><%= commodity.name %>: <%= commodity.sales_volume %></p>
    <% end %>
  <% end %>
<% end %>
```

当面对合法的 `GET /accounts/id/statistic` 请求时，ERB 文件通过判断当前用户是卖家还是管理员，生成不同的 HTML 页面发送回前端。

#### 后端以 `before_action`、`require/permit` 等进行验证

由于用户可能会通过某些手法绕过前端 GUI，直接向后端发送 `GET/POST` 等请求，因此需要进行后端验证。

#### 防范非法 `GET` 请求

例如，某买家用户直接向后端发送 `GET /accounts/id/statistic` 请求。由于本系统仅允许管理员和卖家查看销量信息，因此买家用户的这个请求是不合法的。以 /app/controllers/accounts_controller.rb 为例，讲解后端验证的实现：

```ruby
class AccountsController < ApplicationController
  # ...

  before_action :authenticate_statistic, only: [:statistic]
  
  # ...

  def authenticate_statistic
    redirect_to root_url, alert: "Illegal Behavior!" unless
      current_admin? || current_seller?
  end

  def statistic
  end

  # ...
end
```

利用 Rails 提供的 `before_action` 函数，使得调用 `statistic` 之前先进行 `authenticate_statistic` 验证：只有当前用户为管理员或卖家时，才不会重定向回主页并显示“非法行为”。这样就能够保证买家无法访问销量统计页面。

#### 防范非法 `POST` 请求

例如，某买家用户通过某些手法直接向后端发送 `POST /customers/id/orders` 请求（创建订单），**表单中未指定 `customer_id` 字段**！以后端的 /app/controllers/orders_controller.rb 为例，讲解后端验证的实现：

```ruby
class OrdersController < ApplicationController
  # ...

  # POST /orders or /orders.json
  def create
    @order = Order.new(create_order_params)
    if @order.count <= 0
      redirect_to commodity_url(@order.commodity), alert: "Illegal Count"
    end
    @commodity = Commodity.find(params[:order][:commodity_id])
    @order.price = @commodity.price * params[:order][:count].to_i
    respond_to do |format|
      if @order.save
        format.html {
          redirect_to customer_orders_url(@order.customer),
          notice: "成功创建订单！"
        }
        format.json {
          render :show,
          status: :created,
          location: @order
        }
      else
        format.html {
          render seller_shop_url(@commodity.shop.seller, @commodity.shop),
          status: :unprocessable_entity
        }
        format.json {
          render json: @order.errors,
          status: :unprocessable_entity
        }
      end
    end
  end

  # ...

  private
    
    # ...

    def create_order_params
      params.require(:order)
        .permit(:count, :done, :commodity_id, :customer_id)
    end

    # ...
end
```

其中需关注 `create_order_params` 函数，该函数对前端发来的表单进行字段级验证——检验是否确实发来了所需的字段。该函数中 `require & permit` 要求一定要有 `customer_id` 字段，从而防御了前述非法请求。

再比如，某买家用户通过某些手法直接向后端发送 `POST /customers/id/orders` 请求（创建订单），**表单中指定的商品数量为负数**！上面代码中，`create` 函数中就针对这种情况进行了检测。

## 存储过程、触发器、函数

### 存储与更新

当需要向数据库中插入新的数据或更新数据时，将使用 Rails 的 ORM 提供的各种方法。如：新建一个账户并将其插入到数据库时，使用 `Account` 对象的 `save` 方法：

```ruby
@account = Account.new
@account.name = # ...
@account.password = # ...
@account.role = # ...
@account.save # if success
```

有 OR Mapping 转换如下：

```sql
INSERT
INTO accounts (name, password, role)
VALUES (@account.name, @account.password, @account.role)
```

当要更新数据时，也由 Rails 提供 ORM 提供的各种方法。如：更新一个账户的余额，使用 `Account` 对象的 `update_attribute` 方法：

```ruby
@account.update_attribute(:balance, 0)
```

有 OR Mapping 转换如下：

```sql
UPDATE accounts SET balance = 0 WHERE accounts.id = @account.id
```

### 触发器 - 依赖递归删除

当删除一个数据库对象时，将链式地删除他所拥有的资源。如：删除一个卖家时，会删除他的商铺，商铺中的商品等。此实现由 Rails 的 Dependent-Destroy 支持：

```ruby
# /app/models/seller.rb
class Seller < ApplicationRecord
  # ...
  has_many :shops, dependent: :destroy
end

# /app/models/shop.rb
class Shop < ApplicationRecord
  belongs_to :seller
  has_many :commodities, dependent: :destroy
  # ...
end
```

当欲删除一个 `Seller` 时，首先删除他的所有 `Shop`；欲删除 `Shop`，则首先删除该 `Shop` 的所有 `Commodity`。因此有 OR Mapping 将 `@seller.destroy` 转换如下：

```sql
DELETE FROM commodities WHERE commodities.shop_id IN (
    SELECT shops.id FROM WHERE shops.seller_id = @seller.id
)
DELETE FROM shops WHERE shops.seller_id = @seller.id
DELETE FROM sellers WHERE sellers.id = @seller.id
```

## 实现过程的主要技术、主要模块

### Rails 模型映射数据库实体（OR Mapping）

Rails 提供了 Model 映射数据库实体，例如本项目中 `Seller` 模型（/app/models/seller.rb）就映射了数据库的表格 `sellers`。对于一个 `Seller` 模型的实例 `@seller`，若使用其方法 `@seller.shops`，即对应到 SQL 操作：

```sql
SELECT shops.* FROM shops WHERE shops.seller_id = @seller.id
```

这样，就可以直接操作 Rails Model 对象，间接影响数据库。

### 路由 - 控制器 - 渲染

前端发送请求后，路由接收到前端的请求，随后根据 /config/routes.rb 中定义的路由信息，找到对应的控制器（Controller）与动作（Action）。本项目的路由信息可由如下命令给出：

```shell
$ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
         ... ...    ...                          ...
    accounts GET    /accounts(.:format)          accounts#index
             POST   /accounts(.:format)          accounts#create
 new_account GET    /accounts/new(.:format)      accounts#new
edit_account GET    /accounts/:id/edit(.:format) accounts#edit
     account GET    /accounts/:id(.:format)      accounts#show
         ... ...    ...                          ...
```

随后落入当前请求对应的控制器动作中，由控制器来进行 ORM 操作，并制作前端视图（View）并发回前端。此处，前端视图 HTML 由内嵌 Ruby 代码的 ERB 文件制作。

### 主要技术——函数式程序操作数据

以按类别筛选商品为例，讲述函数式操作数据的实例：

```ruby
class Commodity < ApplicationRecord
  # ...
  scope :filter_by_categories, -> (cset) {
    reject { |c|
      (c.category_ids.map(&:to_i) & cset.reject(&:blank?).map(&:to_i)).empty?
    }
  }
  # ...
end
```

此处定义了一个类方法（Class Method）`filter_by_categories`，该方法接受一个商品类别列表 `cset`，此方法将当前商品列表中满足 `reject` 条件的商品剔除。其中 `reject` 条件为商品所持有的类别（**商品与商品类别是多对多关系**）与 `cset` 交集为空。

### 主要模块—— MVC 模式

<!-- TODO: M-V-C -->

## 系统功能的运行实例

<!-- TODO: Samples -->

## 源程序简要说明

### 路由

路由 /config/routes.rb 如下：

```ruby
Rails.application.routes.draw do
  resources :complaints do
    get 'handle'
    post 'do_handle'
  end
  root :to => 'commodities#index'

  resources :sellers do
    resources :shops
  end

  resources :commodities do
    resources :sections do
      resources :comments do
        get 'reply'
        post 'do_reply'
      end
    end
    collection do
      post 'do_filter'
    end
  end

  resources :categories
  resources :admins
  resources :customers do
    resources :orders do
      post 'purchase'
    end
    resources :records
  end
  resources :accounts do
    collection do
      get 'login'
      post 'do_login'
      get 'logout'
      get 'register'
      post 'do_register'
    end
    get 'top_up'
    post 'do_top_up'
    get 'statistic'
  end
end
```

此处定义了若干 `resources` 资源，这意味着一般情况下他们都可以进行增删改查。若 B 资源嵌套在 A 资源中，则意味着 B 依赖于 A 而存在。

也定义了若干 `get/post` 资源，这些资源直接指定对应的链接与控制器方法。

注意，若某方法嵌套在 `collection do .. end` 中，则意味着这是一个集合方法，而不是针对某一个资源的方法。如 `account` 的 `login` 方法，它并不需要知道账户——不需要提供账户，也能显示登录页面。所以这些集合方法在 `rake routes` 中显示如下：

```shell
login_accounts GET  /accounts/login(.:format)    accounts#login
```

`accounts` 与 `login` 之间没有 `:id`。

### 控制

每一个实体的控制器均位于 /app/controllers/ 下，每一个控制器均内置多个与路由对接的方法。如路由信息所示：

```shell
      Prefix Verb   URI Pattern                  Controller#Action
         ... ...    ...                          ...
    accounts GET    /accounts(.:format)          accounts#index
             POST   /accounts(.:format)          accounts#create
 new_account GET    /accounts/new(.:format)      accounts#new
edit_account GET    /accounts/:id/edit(.:format) accounts#edit
     account GET    /accounts/:id(.:format)      accounts#show
         ... ...    ...                          ...
```

例如：`GET /accounts` 请求将触发 `accounts_controller.rb` 中定义的 `index` 方法。

控制器方法要么处理 `GET` 请求（如：`index` 按约定渲染 index.html.erb），要么根据表单处理 `POST` 请求（如：`accounts#create` 按表单处理 `POST /accounts` 请求）。

### 渲染

控制器处理 `GET` 请求时，使用 Ruby 代码渲染 views 中的前端 HTML（ERB 文件引导渲染），并将 HTML 页面反馈给前端。

## 收获与体会

<!-- TODO -->