package types

import (
	"database/sql"
	"time"
)

type OrderStore interface {
	CreateOrder(Order) error
	GetOrderByID(int) (*Order, error)

	GetOrderByCarrierID(int) ([]OrderCarrierReturnPayload, error)
	GetOrderByGiverID(int) ([]OrderGiverReturnPayload, error)

	GetCarrierOrderByID(orderId int, userId int) (*OrderCarrierReturnPayload, error)
	GetGiverOrderByID(orderId int, userId int) (*OrderGiverReturnPayload, error)

	DeleteOrder(orderId int, userId int) error

	ModifyOrder(int, Order) error

	IsOrderDuplicate(userId int, listingId int) (bool, error)
}

type RegisterOrderPayload struct {
	ListingID     int     `json:"listingId" validate:"required"`
	Weight        float64 `json:"weight" validate:"required"`
	Price         float64 `json:"price" validate:"required"`
	PaymentStatus string  `json:"paymentStatus" validate:"required"`
	OrderStatus   string  `json:"orderStatus"`
	Notes         string  `json:"notes"`
}

type ViewOrderDetailPayload struct {
	ID int `json:"id" validate:"required"`
}

type DeleteOrderPayload ViewOrderDetailPayload

type ModifyOrderPayload struct {
	ID      int                  `json:"id" validate:"required"`
	NewData RegisterOrderPayload `json:"newData" validate:"required"`
}

type OrderGiverReturnPayload struct {
	ID            int       `json:"id"`
	Weight        float64   `json:"weight"`
	Price         float64   `json:"price"`
	PaymentStatus int       `json:"paymentStatus"`
	OrderStatus   int       `json:"orderStatus"`
	Notes         string    `json:"notes"`
	CreatedAt     time.Time `json:"createdAt"`

	Listing struct {
		ID            int       `json:"id"`
		CarrierName   string    `json:"carrierName"`
		Destination   string    `json:"destination"`
		DepartureDate time.Time `json:"departureDate"`
	} `json:"listing"`
}

type OrderCarrierReturnPayload struct {
	Listing struct {
		ID            int       `json:"id"`
		Destination   string    `json:"destination"`
		DepartureDate time.Time `json:"departureDate"`
	} `json:"listing"`

	ID               int       `json:"id"`
	GiverName        string    `json:"giverName"`
	GiverPhoneNumber string    `json:"giverPhoneNumber"`
	Weight           float64   `json:"weight"`
	Price            float64   `json:"price"`
	PaymentStatus    int       `json:"paymentStatus"`
	OrderStatus      int       `json:"orderStatus"`
	Notes            string    `json:"notes"`
	CreatedAt        time.Time `json:"createdAt"`
}

type Order struct {
	ID            int          `json:"id"`
	ListingID     int          `json:"listingId"`
	GiverID       int          `json:"giverId"`
	Weight        float64      `json:"weight"`
	Price         float64      `json:"price"`
	PaymentStatus int          `json:"paymentStatus"`
	OrderStatus   int          `json:"orderStatus"`
	Notes         string       `json:"notes"`
	CreatedAt     time.Time    `json:"createdAt"`
	DeletedAt     sql.NullTime `json:"deletedAt"`
}