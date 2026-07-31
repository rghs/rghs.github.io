+++
title = "{{ replace .Name "-" " " | title }}"
date = {{ .Date }}

showWordCount = false
showReadingTime = false
showTableOfContents = true

draft = true
description = ""
summary = ""

featureimage = "{{ .Site.Params.cdnBaseUrl }}/{{ .Name }}/feature.webp"
card = "{{ .Site.Params.cdnBaseUrl }}/{{ .Name }}/card.webp"

categories = ["Galleries"]
tags = [""]
+++
