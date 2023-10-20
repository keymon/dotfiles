# k8saas-cli ![release](./release.svg)

A CLI for interacting with [k8saas-api](https://github.com/confluentinc/cire-k8saas-api/)

## Installing

Prebuilt binaries are available: https://github.com/confluentinc/cire-k8saas-cli/releases/.

## Building

You'll need Go 1.15:

```sh
make build
```

## Authentication

Calling the k8saas API requires you to be authenticated. The CLI will
automatically pick up your Vault token from `$HOME/.vault-token`, so there is
nothing for you to do aside from successfully completing `cclogin` against any
environment.

## Commands

The result of any subcommand is either an error message, or a cluster spec
dumped as JSON so you can pipe it into other commands, like `jq`.

At the root the CLI takes one flag: `api-env`. This defaults to the production
deployment of k8saas and should be where any clusters that used to be in
`cc-terraform` get created. You can switch to `stag` or `devel` if you want
to target a different k8saas environment.

### create

This subcommand lets you create new clusters. It will tell you about any
missing required flags. All flags are automatically generated and applied based
on [k8saas-structs](https://github.com/confluentinc/cire-k8saas-structs/blob/master/pkg/grpc/v1/service.proto#L).

The flag name matches the `name=` pair in the `protobuf` struct tag, with
underscores replaced by dashes. Flags for values in `AksConfig`, `EksConfig`
and `GkeConfig` are prefixed with `aks.`, `eks.` or `gke.`.

#### Required flags

If you want to know which flags are required, see the comments on the protobuf
definition.

### get

This subcommand lets you retrieve a single cluster, by its cluster ID.

### delete

This subcommand lets you delete a single cluster, by its cluster ID.

### Example

```shell script
# Ensure you have a fresh vault token by simply running caaslogin
# This also verifies that you have the necessary permissions to perform the following statements
cclogin -e devel -c aws -r us-west-2 -b 0
```

```shell script
./k8saas create \
    -name "cli-example" \
    -region eu-west-1 \
    -env devel \
    -cloud aws \
    -image-registry "037803949979.dkr.ecr.eu-west-1.amazonaws.com/confluentinc" \ # This varies by region. k8saas will grant access to the registry.
    -instance-type "r5.xlarge" \
    -eks.master-security-groups "sg-0fd1b86f58624d7bf" \
    -eks.subnet-ids "subnet-32c9c46a,subnet-5ddb1a3a,subnet-e16ea3a8" \
    -eks.vpc-id "vpc-949f5ef3" \
    -eks.worker-security-groups "sg-0cd9d39259c6c121f" 
```

The response will include an ID which can be used to retrieve the cluster:
```shell script
k8saas get k8s-c6jh7
```

Note: The status of the cluster can be found in `cluster.state`. 
It's an integer which maps to a state constant in the [proto definition](https://github.com/confluentinc/cire-k8saas-structs/blob/master/pkg/grpc/v1/service.proto#L190).

After the cluster reached the state `4`/`active` you can use it from the region specific bastion. Don't forget to run `configure_kubecfg`.
The kubeconfig context will be: "k8saas-${ID}"

To delete your cluster:
```shell script
k8saas delete k8s-c6jh7
```