#!/bin/bash

adb pair 192.168.31.7:$1

adb connect 192.168.31.7:$2

