type Category struct {
	ID   bson.ObjectId `bson:"_id"`
	Name string
}

mix phoenix.gen.html Category categories name:string
mix phoenix.gen.json API.Category categories name:string --no-model

mix phoenix.gen.html Product products category_id:references:categories name:string description:string cover:string samples:array:string summary:string polish_print_price:integer print_price:integer display_type:string

mix phoenix.gen.json API.Product products category_id:references:categories name:string description:string cover:string samples:array:string summary:string polish_print_price:integer print_price:integer display_type:string --no-model



type Product struct {
	ID               bson.ObjectId `bson:"_id"`
	CategoryID       bson.ObjectId
	Name             string
	Description      string
	Cover            string
	Samples          []string
	Summary          string
	PolishPrintPrice int
	PrintPrice       int
	DisplayType      string
	GoodGroups       []GoodGroup
}


type Good struct {
	ID            bson.ObjectId `bson:"_id"`
	Name          string
	Description   string
	Color         string
	Specification string
	Price         int
	Discount      string
}

type GoodGroup struct {
	ID           bson.ObjectId `bson:"_id"`
	Name         string
	MaxSelection int
	Goods        []Good
}

type Order struct {
	ID           bson.ObjectId `bson:"_id"`
	UserID       bson.ObjectId
	Product      Product
	Status       string
	SystemStatus string
	PaidStatus   int
	Price        int
	Store        Store
	Trade        Trade
	// Express      Express
}

type Trade struct {
	Provider string
	Raw      string
}


type PayConfig struct {
	ID        bson.ObjectId `bson:"_id"`
	Name      string
	URL       string
	AppID     string
	AppSecret string
	PublicKey string
	Partner   string
}


type StoreService struct {
	ID          bson.ObjectId `bson:"_id"`
	Name        string
	Icon        string
	Description string
}

type Store struct {
	ID          bson.ObjectId `bson:"_id"`
	Name        string
	Country     string
	Province    string
	City        string
	Address     string
	MapLocation string
	Phone       string
	Photo       string
	OpenAt      time.Time
	CloseAt     time.Time
	TimeCost    int
	Services    []StoreService
}

type User struct {
	ID           bson.ObjectId `bson:"_id"`
	Username     string
	Password     string `json:"-"` // 密码不能透露
	Role         string
	IsAdmin      bool
	IsManager    bool
	Mobile       string
	IsActive     bool
	WeChatOpenID string
	WeChatUID    string
	Realname     string
	Nickname     string
	Profile      Profile
}

type Profile struct {
	Gender   string
	Age      string
	Avatar   string
	Grcode   string
	Country  string
	Province string
	City     string
	Language string
}
