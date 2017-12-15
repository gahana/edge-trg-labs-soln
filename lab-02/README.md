# API Product Lab

1. Create API Products
	- trg-ordering-product
		+ /users, /categories, /products, /orders, /skus
	- trg-inventory-product
		+ /skus, /products
	- trg-catalog-product
		+ /categories, /products
2. Create Developers
	- Ordering developer
	- Inventory developer
	- Catalog developer
3. Create Apps
	- Ordering web app
	- Inveotry app
	- Catalog App
4. Add verify API key policy proxies
	- /categories
	- /orders
	- /products
	- /skus
	- /stores
	- /users


# Tests

```bash
$ curl -i -n https://srinis-test.apigee.net/catalog/v1/categories?apikey=
$ curl -i -n https://srinis-test.apigee.net/catalog/v1/products?apikey=
$ curl -i -n https://srinis-test.apigee.net/ordering/v1/orders?apikey=
$ curl -i -n https://srinis-test.apigee.net/ordering/v1/users?apikey=
$ curl -i -n https://srinis-test.apigee.net/inventory/v1/skus?apikey=
```

/products should be accessible by consumer key from all 3 apps

Revoke ordering app consumer key and test that it fails for /orders