#!/usr/bin/env bash
gcloud compute instances create reddit-immutable \
           --boot-disk-size=10GB \
           --image-family reddit-full \
           --machine-type=g1-small \
           --tags puma-server \
           --restart-on-failure
gcloud compute firewall-rules create puma-input \
      --action allow \
      --target-tags puma-server \
      --source-ranges 0.0.0.0/0 \
      --rules tcp:9292