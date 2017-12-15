#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USAGE="Usage: deploy [all|categories|orders|product|skus|stores|users]"
ORG="srinis"
ENV="test"

if [ -z "$1" ]; then
	set -- "all"
fi
set -eu

cd $BASEDIR

if [ "$1" = "categories" ] || [ "$1" = "all" ] ; then
	apigeetool deployproxy -u $EDGE_USERNAME -p $EDGE_PASSWORD -o $ORG -e $ENV -n trg-categories-api -d ./trg-categories-api
fi

if [ "$1" = "orders" ] || [ "$1" = "all" ] ; then
	apigeetool deployproxy -u $EDGE_USERNAME -p $EDGE_PASSWORD -o $ORG -e $ENV -n trg-orders-api -d ./trg-orders-api
fi

if [ "$1" = "product" ] || [ "$1" = "all" ] ; then
	apigeetool deployproxy -u $EDGE_USERNAME -p $EDGE_PASSWORD -o $ORG -e $ENV -n trg-product-api -d ./trg-product-api
fi

if [ "$1" = "skus" ] || [ "$1" = "all" ] ; then
	apigeetool deployproxy -u $EDGE_USERNAME -p $EDGE_PASSWORD -o $ORG -e $ENV -n trg-skus-api -d ./trg-skus-api
fi

if [ "$1" = "stores" ] || [ "$1" = "all" ] ; then
	apigeetool deployproxy -u $EDGE_USERNAME -p $EDGE_PASSWORD -o $ORG -e $ENV -n trg-stores-api -d ./trg-stores-api
fi

if [ "$1" = "users" ] || [ "$1" = "all" ] ; then
	apigeetool deployproxy -u $EDGE_USERNAME -p $EDGE_PASSWORD -o $ORG -e $ENV -n trg-users-api -d ./trg-users-api
fi

