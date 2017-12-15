# Edge Fundamentals

1. Create OpenAPI Spec
2. Generate API Proxy from OpenAPI Spec
3. Map proxy path to target paths
4. Create named target server
5. Use named target server in proxy

## 1. Create OpenAPI Spec

Deciding on base path:

- Products
	+ /catalog/v1/products
- Categories
	+ /catalog/v1/categories
- Orders
	+ /ordering/v1/orders
- Users
	+ /ordering/v1/users
- SKUs
	+ /inventory/v1/skus
- Stores
	+ /sales/v1/stores

Sample spec for products

```json
{
  "host": "org-env.apigee.net",
  "basePath": "/catalog/v1/products",
  "paths": {
    "/": { ... },
    "/{product_id}": { ... },
    "/{product_id}/skus": { ... }
  }
}

```

## 2. Create named target server

You can create http based target servers via UI but for TLS enabled target servers management API is the better way.

Get target servers

```bash
$ curl -i -n -X GET 'https://api.enterprise.apigee.com/v1/o/srinis/e/test/targetservers'
```

Create target server

```bash
$ curl -i -n -H "Content-Type: application/json" -X POST 'https://api.enterprise.apigee.com/v1/o/srinis/e/test/targetservers' -d '{
  "name" : "trg-baas-target",
  "host" : "apibaas-trial.apigee.net",
  "isEnabled" : true,
  "port" : 443,
  "sSLInfo": {
      "enabled": "true"
    }
 }'
```

Check target servers

```bash
$ curl -i -n -X GET 'https://api.enterprise.apigee.com/v1/o/srinis/e/test/targetservers/trg-baas-target'
```

Update target server

```bash
$ curl -i -n -H "Content-Type: application/json" -X PUT 'https://api.enterprise.apigee.com/v1/o/srinis/e/test/targetservers/trg-baas-target' -d '{
  "name" : "trg-baas-target",
  "host" : "apibaas-trial.apigee.net",
  "isEnabled" : true,
  "port" : 443,
  "sSLInfo": {
      "enabled": "true"
    }
 }'
```

## 3. Generate API Proxy from OpenAPI Spec

Name: trg-<resource>-api
Base Path: /<divsion>/v1/<resource>
Target Server: trg-baas-target
Target Path: /org/app/collection

## 4. Define target server on proxy

Under Target Endpoints click on `default` and update

```xml
<HTTPTargetConnection>
    <LoadBalancer>
        <Server name="trg-baas-target"/>
    </LoadBalancer>
    <Path>/org/app/collection</Path>
</HTTPTargetConnection>
```

## 3. Map proxy path to target path (/products/id/skus to /products/id/availability)

1. Extract productId with Extract Variables policy on proxy request flow
2. Create a new target endpoint (availability) with path as /org/app/products/{productId}/availability
3. On proxy XML (default) route to availability target
4. On target request flow set "target.copy.pathsuffix" to false via JavaScript policy callout


## Tests

```bash
$ curl -i -n https://srinis-test.apigee.net/catalog/v1/categories
$ curl -i -n https://srinis-test.apigee.net/catalog/v1/products
$ curl -i -n https://srinis-test.apigee.net/ordering/v1/orders
$ curl -i -n https://srinis-test.apigee.net/ordering/v1/users
$ curl -i -n https://srinis-test.apigee.net/inventory/v1/skus
$ curl -i -n https://srinis-test.apigee.net/sales/v1/stores
```

