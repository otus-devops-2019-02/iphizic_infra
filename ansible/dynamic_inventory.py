#!/usr/bin/python3.6
import argparse
import json


def load_tfstate(statefile):
    with open(statefile, "r") as read_file:
        data = json.load(read_file)
    return data


def host_list(group):
    terraform_list = load_tfstate("../terraform/prod/terraform.tfstate")

    for module in terraform_list['modules']:
        if group in module['path']:
            ip = module['outputs']['external_ip']['value'][0]
            return ip

    return main_host_list


def parser_init():
    parser = argparse.ArgumentParser(description='Backup system AISRK')
    parser.add_argument("-l",
                        "--list",
                        help="increase output verbosity",
                        action="store_true")
    parser.add_argument("--host",
                        help="make backup once",
                        type=str)
    return parser.parse_args()


if __name__ == "__main__":
    argument = parser_init()

    main_host_list = {
        "app": {
            "hosts": [
                "appserver"
            ]
        },
        "db": {
            "hosts": [
                "dbserver"
                ]
        },
        # "_meta": {
        #     "hostvars": {}
        # }
    }

    if argument.list:
        print(main_host_list)

    if argument.host is not None:
        host_vars = {"ansible_host": host_list(argument.host.replace('server', ''))}
        print(host_vars)
