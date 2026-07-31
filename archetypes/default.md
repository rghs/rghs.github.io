+++
title = "{{ replace .Name "-" " " | title }}"
date = {{ .Date }}
draft = true

description = ""
summary = ""

featureimage = "{{ .Site.Params.cdnBaseUrl }}/{{ .Name }}/feature.webp"
card = "{{ .Site.Params.cdnBaseUrl }}/{{ .Name }}/card.webp"

categories = [""]
tags = [""]
+++
