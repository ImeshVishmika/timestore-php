<p align="center">
  <h1 align="center">🛒 TimeStore</h1>
  <p align="center">
    A custom PHP e-commerce platform built with MVC architecture, a front controller, and a custom routing system.
  </p>
</p>

<p align="center">

![PHP](https://img.shields.io/badge/PHP-8.x-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVC-green)
![Routing](https://img.shields.io/badge/Routing-Custom-orange)
![Payments](https://img.shields.io/badge/Payments-PayHere-purple)
![Database](https://img.shields.io/badge/Database-MySQL-red)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

</p>

---

# 🌐 Live Demo

Demo URL  https://timestore.imeshvishmika.me


---

# 📖 Project Overview

**TimeStore** is a PHP-based e-commerce application built around a custom MVC flow with a front controller and route configuration in `Router.php`. The project uses direct controller-to-model access, server-side validation, session-based auth, and a MySQL schema for product, customer, cart, order, and address data.

The application supports storefront browsing, product model management, user accounts, cart and wishlist operations, and admin-side dashboards for product and customer administration. The architecture is intentionally lightweight and code-driven rather than framework-based, which matches the project’s actual implementation and naming patterns.

---

# ⭐ Features

## 👤 User Features

- Browse the product catalog and product variants
- Search products by keyword and filter by product model data
- Add and remove items from the cart
- Save items in a watchlist
- View purchase history and user profile details
- Update personal address information
- Place orders with the **PayHere sandbox payment gateway**
- View and exchange messages with administrators

---

## 🛠 Admin Features

- Add and update product entries and model variants
- Remove products and product records
- View product revenue and sales statistics
- Manage users and customer details
- Review order records and order status
- Manage brand and category records
- Review message activity between users and admins

---

# 🧰 Technology Stack

| Layer | Implementation |
|------|------|
| Backend | PHP 8.x |
| Architecture | MVC with a front controller |
| Routing | Custom route map in `Router.php` |
| Auth | Session-based role checks via middleware |
| Data access | Model classes under `app/model` |
| Database | MySQL |
| Web server | Apache / PHP-FPM |
| Reverse proxy | Nginx |
| Payment | PayHere sandbox |
| Front-end assets | Plain PHP views and static files under `public/assets` |

---

# 🏗 System Architecture

```mermaid
flowchart TD

A[Client Browser]:::client --> B[Nginx Reverse Proxy]:::infra
B --> C[Apache Web Server]:::infra
C --> D[PHP-FPM]:::infra
D --> E[public/index.php Front Controller]:::app

E --> F[Router]:::app
F --> G[Middleware auth checks]:::security
G --> H[Web Controllers / API Controllers]:::app
H --> I[Model classes]:::app
I --> J[(MySQL Database)]:::db

classDef client fill:#4CAF50,color:#fff
classDef infra fill:#FF9800,color:#fff
classDef app fill:#2196F3,color:#fff
classDef security fill:#F44336,color:#fff
classDef db fill:#9C27B0,color:#fff
```
---

# 🔄 Request Lifecycle

```mermaid
sequenceDiagram

participant User
participant Nginx
participant Apache
participant Router
participant Middleware
participant Controller
participant Model
participant Database

User->>Nginx: HTTP request
Nginx->>Apache: Forward request
Apache->>Router: Dispatch through index.php

Router->>Middleware: Check allowed roles
Middleware-->>Router: Access granted or denied

Router->>Controller: Resolve controller and action
Controller->>Model: Execute query or business logic
Model->>Database: Read or write data
Database-->>Model: Result set
Model-->>Controller: Prepared response
Controller-->>User: JSON or HTML output
```
---

# 🗄 Database Design

The application database is modeled to match the current MySQL schema in the project dump. The main entities are brands, products, product variants, users, addresses, carts, watchlists, and purchase history.

```mermaid
erDiagram
    BRAND {
        int brand_id PK
        varchar brand_name
    }

    PRODUCT {
        int product_id PK
        varchar product_name
        int sold_count
        int brand_id FK
    }

    GENDER {
        int id PK
        varchar gender
    }

    PRODUCT_HAS_MODEL {
        int model_id PK
        varchar model
        double price
        int qty
        datetime added_time
        int gender_id FK
        int sold_count
        int product_id FK
    }

    CATEGORY {
        int category_id PK
        varchar category_name
    }

    PRODUCT_HAS_CATEGORY {
        int product_id PK,FK
        int category_category_id PK,FK
    }

    PRODUCT_IMG {
        varchar img_path PK
        int product_id FK
    }

    USERS {
        varchar fname
        varchar lname
        varchar password
        varchar mobile
        varchar email PK
        int gender_id FK
    }

    USER_ADDRESS {
        varchar address_line1
        varchar address_line2
        int city_id FK
        varchar users_email PK,FK
    }

    PROVINCES {
        int province_id PK
        varchar name_en
        varchar name_si
        varchar name_ta
    }

    DISTRICTS {
        int district_id PK
        int province_id FK
        varchar name_en
        varchar name_si
        varchar name_ta
    }

    CITIES {
        int city_id PK
        int district_id FK
        varchar name_en
        varchar name_si
        varchar name_ta
        varchar postcode
        double latitude
        double longitude
    }

    CART {
        int cart_id PK
        int product_id FK
        int cart_qty
        varchar users_email FK
    }

    WATCHLIST {
        int watchlist_id PK
        int product_id FK
        varchar users_email FK
    }

    RATINGS {
        varchar user_email PK,FK
        int product_id PK,FK
        varchar ratings
        varchar comment
    }

    USER_HISTORY {
        int id PK
        varchar user_id FK
        int product_id FK
        datetime buy_datetime
        int amount
    }

    BRAND ||--o{ PRODUCT : contains
    PRODUCT ||--o{ PRODUCT_HAS_MODEL : has
    GENDER ||--o{ USERS : defines
    GENDER ||--o{ PRODUCT_HAS_MODEL : defines
    PRODUCT_HAS_MODEL ||--o{ PRODUCT_HAS_CATEGORY : mapped_by
    CATEGORY ||--o{ PRODUCT_HAS_CATEGORY : classified_as
    PRODUCT_HAS_MODEL ||--o{ PRODUCT_IMG : has
    USERS ||--o{ CART : owns
    PRODUCT_HAS_MODEL ||--o{ CART : added_to
    USERS ||--o{ WATCHLIST : saves
    PRODUCT_HAS_MODEL ||--o{ WATCHLIST : watched
    USERS ||--o{ RATINGS : leaves
    PRODUCT_HAS_MODEL ||--o{ RATINGS : rated
    USERS ||--o| USER_ADDRESS : has
    CITIES ||--o{ USER_ADDRESS : contains
    PROVINCES ||--o{ DISTRICTS : contains
    DISTRICTS ||--o{ CITIES : contains
    USERS ||--o{ USER_HISTORY : purchases
    PRODUCT_HAS_MODEL ||--o{ USER_HISTORY : purchased_as
```

Core schema tables:

- `brand`: watch brands such as G-Shock
- `product`: base product row for each item family
- `product_has_model`: product variants/models with price, stock, gender, and sold count
- `category` + `product_has_category`: many-to-many mapping between product models and categories
- `product_img`: image paths associated with each product model
- `users`: registered customer accounts
- `user_address`: customer shipping address linked to a city
- `provinces`, `districts`, `cities`: Sri Lankan location hierarchy used for addresses
- `cart`: items currently in a user’s cart
- `watchlist`: saved products for later viewing
- `ratings`: product ratings and comments left by users
- `user_history`: product purchase history for each user

---

# 🔐 Security

The project applies security checks at the routing layer before reaching controller logic. Route definitions in `Router.php` can specify required roles such as `admin` or `user`, and the auth middleware validates that session state before dispatch.

Current implementation details:

- Session-based authentication using the auth middleware
- Role-based route restrictions through `allows` entries
- Controller access controlled before action execution
- Payment flows and sensitive endpoints restricted by role checks

This is a lightweight backend security model rather than a full framework middleware stack, which matches the project’s actual implementation.

---

# 📁 Project Structure

```text
timestore/
├── app/
│   ├── controllers/
│   │   ├── Api/
│   │   │   ├── BrandController.php
│   │   │   ├── CartController.php
│   │   │   ├── DeliveryMethodController.php
│   │   │   ├── HistoryController.php
│   │   │   ├── MessageController.php
│   │   │   ├── OrderController.php
│   │   │   ├── ProductController.php
│   │   │   ├── SearchController.php
│   │   │   ├── UserController.php
│   │   │   └── WishlistController.php
│   │   └── Web/
│   │       ├── AdminPageController.php
│   │       ├── ImgController.php
│   │       └── UserPageController.php
│   ├── core/
│   │   ├── Router.php
│   │   └── Validator.php
│   ├── middleware/
│   │   └── auth.php
│   ├── model/
│   │   ├── admin.php
│   │   ├── brand.php
│   │   ├── cart.php
│   │   ├── customers.php
│   │   ├── delivery.php
│   │   ├── history.php
│   │   ├── Img.php
│   │   ├── messages.php
│   │   ├── orders.php
│   │   ├── product.php
│   │   ├── search.php
│   │   └── wishlist.php
│   └── views/
│       ├── Admin/
│       └── User/
├── config/
│   ├── connection.php
│   └── payhere.php
├── public/
│   ├── index.php
│   ├── loadImg.php
│   └── assets/
│       ├── Script/
│       └── style/
├── media/
│   ├── icons/
│   ├── poster/
│   ├── product/
│   └── userprofile/
├── README.md
├── SECURITY_AUDIT_REPORT.md
└── Dockerfile
```
