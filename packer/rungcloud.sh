#!/usr/bin/env bash
gcloud compute instances create reddit-immutable \
           --boot-disk-size=10GB \
           --image-family reddit-base-immutable \
           --machine-type=g1-small \
           --tags puma-server \
           --restart-on-failure
