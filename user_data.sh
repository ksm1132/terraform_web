#!/bin/bash
amazon-linux-extars install -y docker
systemctl start docker
systemctl enable docker