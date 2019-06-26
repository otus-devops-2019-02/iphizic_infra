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
            config = {"ansible_host": module['outputs']['external_ip']['value'][0] }

        if "db" in module['path']:
            db_ip = module['resources']['google_compute_instance.db']['primary']['attributes']['network_interface.0.network_ip']

    if group == "app":
      config.update({ "db_host": db_ip})

    return config


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
         "all": {
            "hosts": [
                "appserver",
                "dbserver"
            ],
            "children": [
                "app",
                "db"
            ]
        },
        "app": {
            "hosts": [
                "appserver"
            ],
            "children": [
            ]
        },
        "db": {
            "hosts": [
                "dbserver"
                ],
            "children": [
            ]
        }
    }

    if argument.list:
        print(json.dumps(main_host_list))

    if argument.host is not None:
        host_vars = host_list(argument.host.replace('server', ''))
        print(json.dumps(host_vars))
