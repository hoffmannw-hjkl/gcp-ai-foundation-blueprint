# 🏗️ Schémas d'Architecture Officiels (Dendrite v3.3 Bento Matrix & GCP Draw)

Ce document centralise les **schémas d'architecture as-code** de **GCP AI Foundation Blueprint — Landing Zone & M1L1 Agentic Harness** selon deux standards complémentaires :
1. **Dendrite v3.3 (Executive Standard 16:9 — Bento Matrix)** : Schéma haute-densité validé sans collision géométrique, exportable en **SVG interactif** et **Draw.io / Lucidchart (`.drawio`)**.
2. **GCP Draw (`go/gcpdraw`)** : Spécification déclarative rapide pour l'outil interne Google Cloud Draw.

---

## 🚀 Accès Rapide & Fichiers Sources Versionnés

| Format / Outil | Fichier / Lien Direct | Usage Recommandé |
| :--- | :--- | :--- |
| **🎨 Ouvrir dans Dendrite Studio (1-Click)** | [**Launch in Dendrite Studio ↗**](https://dendrite-758054785671.cr.gclb.goog/#code=cmVuZGVyT3JkZXI6IG5vZGVzLWZpcnN0CmRpcmVjdGlvbjogZG93bgoKY29uc3QgR2NwQmx1ZSA9ICIjMWE3M2U4Igpjb25zdCBHY3BHcmVlbiA9ICIjMWU4ZTNlIgpjb25zdCBFbWVyYWxkVGVhbCA9ICIjMGQ5NDg4Igpjb25zdCBEYXJrU2xhdGUgPSAiIzIwMjEyNCIKY29uc3QgU3ViVGV4dCA9ICIjNWY2MzY4Igpjb25zdCBDYXJkQm9yZGVyID0gIiNkYWRjZTAiCmNvbnN0IEJ1c1N0cm9rZSA9ICIjMzM0MTU1Igpjb25zdCBTdXJmYWNlV2hpdGUgPSAiI2ZmZmZmZiIKClN0eWxlIEBHaG9zdCB7CiAgZmlsbDogdHJhbnNwYXJlbnQsIHN0cm9rZVdpZHRoOiAwLCBmb250Q29sb3I6IHRyYW5zcGFyZW50LCBwYWRkaW5nOiAwCn0KU3R5bGUgQEFyY2hpdGVjdHVyZVJvb3QgewogIGZpbGw6ICIjZjhmYWZkIiwgc3Ryb2tlQ29sb3I6ICIjYzJkN2Y1Iiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxNiwKICBwYWRkaW5nOiAyMiwgZ2FwOiAxOCwgZm9udENvbG9yOiAiIzNjNDA0MyIsIGZvbnRTaXplOiAyMiwgbGFiZWxXZWlnaHQ6IGJvbGQsCiAgaWNvbjogIkdvb2dsZUNsb3VkIiwgaWNvblNpemU6IDI4Cn0KU3R5bGUgQFBlcmltZXRlclpvbmUgewogIGZpbGw6ICIjZThmMGZlIiwgc3Ryb2tlQ29sb3I6ICIjOGFiNGY4Iiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxMiwKICBwYWRkaW5nOiAxNiwgZ2FwOiAxNiwgZm9udENvbG9yOiAkRGFya1NsYXRlLCBmb250U2l6ZTogMTUsIGxhYmVsV2VpZ2h0OiBib2xkCn0KU3R5bGUgQEV4ZWN1dGlvblpvbmUgewogIGZpbGw6ICIjZmNlOGU2Iiwgc3Ryb2tlQ29sb3I6ICIjZjZhZWE5Iiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxMiwKICBwYWRkaW5nOiAxNiwgZ2FwOiAxNiwgZm9udENvbG9yOiAkRGFya1NsYXRlLCBmb250U2l6ZTogMTUsIGxhYmVsV2VpZ2h0OiBib2xkCn0KU3R5bGUgQEdvdmVybmFuY2Vab25lIHsKICBmaWxsOiAiI2U2ZjRlYSIsIHN0cm9rZUNvbG9yOiAiIzgxYzk5NSIsIHN0cm9rZVdpZHRoOiAxLjUsIGJvcmRlclJhZGl1czogMTIsCiAgcGFkZGluZzogMTYsIGdhcDogMTQsIGZvbnRDb2xvcjogJERhcmtTbGF0ZSwgZm9udFNpemU6IDE1LCBsYWJlbFdlaWdodDogYm9sZAp9ClN0eWxlIEBSZXNvdXJjZVpvbmUgewogIGZpbGw6ICIjZmVmN2UwIiwgc3Ryb2tlQ29sb3I6ICIjZmRlMjkzIiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxMiwKICBwYWRkaW5nOiAxNiwgZ2FwOiAxNiwgZm9udENvbG9yOiAkRGFya1NsYXRlLCBmb250U2l6ZTogMTUsIGxhYmVsV2VpZ2h0OiBib2xkCn0KU3R5bGUgQFBlYWNoU3ViR3JvdXAgewogIGZpbGw6ICIjZjhkM2M4Iiwgc3Ryb2tlQ29sb3I6IGRhcmtlbigiI2Y4ZDNjOCIsIDEyKSwgc3Ryb2tlV2lkdGg6IDEsIGJvcmRlclJhZGl1czogMTAsCiAgcGFkZGluZzogMTIsIGdhcDogMTAsIGZvbnRDb2xvcjogJERhcmtTbGF0ZSwgZm9udFNpemU6IDEzLCBsYWJlbFdlaWdodDogYm9sZAp9ClN0eWxlIEBHcmVlblN1Ykdyb3VwIHsKICBmaWxsOiAiI2NlZWFkNiIsIHN0cm9rZUNvbG9yOiBkYXJrZW4oIiNjZWVhZDYiLCAxNCksIHN0cm9rZVdpZHRoOiAxLCBib3JkZXJSYWRpdXM6IDEwLAogIHBhZGRpbmc6IDEwLCBnYXA6IDcsIGZvbnRDb2xvcjogJERhcmtTbGF0ZSwgZm9udFNpemU6IDEzLCBsYWJlbFdlaWdodDogYm9sZAp9ClN0eWxlIEBBbWJlclN1Ykdyb3VwIHsKICBmaWxsOiAiI2Y5ZTRhNyIsIHN0cm9rZUNvbG9yOiBkYXJrZW4oIiNmOWU0YTciLCAxNCksIHN0cm9rZVdpZHRoOiAxLCBib3JkZXJSYWRpdXM6IDEwLAogIHBhZGRpbmc6IDEyLCBnYXA6IDEyLCBmb250Q29sb3I6ICREYXJrU2xhdGUsIGZvbnRTaXplOiAxMywgbGFiZWxXZWlnaHQ6IGJvbGQKfQpTdHlsZSBAQWN0b3JDYXJkIHsKICB3aWR0aDogMTgwLCBoZWlnaHQ6IDU2LAogIGZpbGw6ICRTdXJmYWNlV2hpdGUsIHN0cm9rZUNvbG9yOiAkQ2FyZEJvcmRlciwgc3Ryb2tlV2lkdGg6IDEsIGJvcmRlclJhZGl1czogOCwKICBmb250Q29sb3I6ICREYXJrU2xhdGUsIHN1YkZvbnRDb2xvcjogJFN1YlRleHQsCiAgZm9udFNpemU6IDE0LCBzdWJGb250U2l6ZTogMTEsIGxhYmVsV2VpZ2h0OiBib2xkLAogIHRleHRBbGlnbjogImxlZnQiLCB0ZXh0VkFsaWduOiAibWlkZGxlIiwKICBpY29uUG9zaXRpb246ICJsZWZ0IiwgaWNvblNpemU6IDI4LCBwYWRkaW5nOiAxMCwgc2hhZG93OiB0cnVlCn0KU3R5bGUgQFByb2R1Y3RDYXJkIHsKICB3aWR0aDogMTY4LCBoZWlnaHQ6IDU4LAogIGZpbGw6ICRTdXJmYWNlV2hpdGUsIHN0cm9rZUNvbG9yOiAkQ2FyZEJvcmRlciwgc3Ryb2tlV2lkdGg6IDEsIGJvcmRlclJhZGl1czogOCwKICBmb250Q29sb3I6ICREYXJrU2xhdGUsIHN1YkZvbnRDb2xvcjogJFN1YlRleHQsCiAgZm9udFNpemU6IDEzLjUsIHN1YkZvbnRTaXplOiAxMSwgbGFiZWxXZWlnaHQ6IGJvbGQsCiAgdGV4dEFsaWduOiAibGVmdCIsIHRleHRWQWxpZ246ICJtaWRkbGUiLAogIGljb25Qb3NpdGlvbjogImxlZnQiLCBpY29uU2l6ZTogMjgsIHBhZGRpbmc6IDEwLCBzaGFkb3c6IHRydWUKfQpTdHlsZSBAR2F0ZXdheUh1YkNhcmQgewogIGJhc2U6IEBQcm9kdWN0Q2FyZCwKICB3aWR0aDogMTk2LCBoZWlnaHQ6IDY2LCBzdHJva2VDb2xvcjogJEdjcEJsdWUsIHN0cm9rZVdpZHRoOiAyLAogIGZvbnRTaXplOiAxNC41LCBzdWJGb250U2l6ZTogMTEsIGljb25TaXplOiAzMCwgcGFkZGluZzogMTIKfQpTdHlsZSBAUG9saWN5UGlsbCB7CiAgd2lkdGg6IDIyOCwgaGVpZ2h0OiAzMiwKICBmaWxsOiAkU3VyZmFjZVdoaXRlLCBzdHJva2VDb2xvcjogIiM5YWEwYTYiLCBzdHJva2VXaWR0aDogMSwgYm9yZGVyUmFkaXVzOiAxNiwKICBmb250Q29sb3I6ICREYXJrU2xhdGUsIGZvbnRTaXplOiAxMi41LCBsYWJlbFdlaWdodDogYm9sZCwKICB0ZXh0QWxpZ246ICJsZWZ0IiwgdGV4dFZBbGlnbjogIm1pZGRsZSIsCiAgaWNvblBvc2l0aW9uOiAibGVmdCIsIGljb25TaXplOiAxNiwgcGFkZGluZzogMTAsIHNoYWRvdzogdHJ1ZQp9Cgpab25lIEBHQ1BfQUlfRm91bmRhdGlvbl9CbHVlcHJpbnQgewogIHRpdGxlOiAiR0NQIEFJIEZvdW5kYXRpb24gQmx1ZXByaW50IOKAlCBFbnRlcnByaXNlIExhbmRpbmcgWm9uZSAoZXVyb3BlLXdlc3QxKSIKICBzdHlsZTogQEFyY2hpdGVjdHVyZVJvb3QKICBsYXlvdXQ6IG1hdHJpeAogIGFyZWFzOiBbCiAgICAiejEgejEgejEgejEgejEiLAogICAgInozIHozIHoyIHoyIHoyIiwKICAgICJ6NCB6NCB6NCB6NCB6NCIKICBdCiAgc2l6ZXM6IFsiMS4wNWZyIiwgIjEuMDVmciIsICIwLjk2ZnIiLCAiMC45NmZyIiwgIjAuOTZmciJdCiAgZ2FwOiAyMAoKICBab25lIEBab25lMV9QZXJpbWV0ZXIgewogICAgYXJlYTogInoxIgogICAgdGl0bGU6ICIxLiBaZXJvLVRydXN0IEVkZ2UgUGVyaW1ldGVyICYgSW5ncmVzcyAobW9kdWxlcy9zZWN1cml0eS13YWYgJiBuZXR3b3JraW5nKSIKICAgIHN0eWxlOiBAUGVyaW1ldGVyWm9uZQogICAgbGF5b3V0OiByb3csIGdhcDogMTgsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgW2VudGVycHJpc2VfdXNlcnM6ICJFbnRlcnByaXNlIFVzZXJzIiB8ICJIVFRQUyBDbGllbnRzIl0geyBzdHlsZTogQEFjdG9yQ2FyZCwgaWNvbjogIlVzZXJzIiB9CiAgICBbY2xvdWRfYXJtb3Jfd2FmOiAiQ2xvdWQgQXJtb3IgV0FGIiB8ICJPV0FTUCBUb3AgMTAgJiBERG9TIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTg2LCBpY29uOiAiQ2xvdWRBcm1vciIgfQogICAgW2dsb2JhbF9sYjogIkdsb2JhbCBIVFRQUyBMQiIgfCAiQW55Y2FzdCAmIE1hbmFnZWQgU1NMIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTg2LCBpY29uOiAiQ2xvdWRMb2FkQmFsYW5jaW5nIiB9CiAgICBbaWFwX3Byb3h5OiAiSWRlbnRpdHktQXdhcmUgUHJveHkiIHwgIlplcm8tVHJ1c3QgT0lEQyBBdXRoIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTg4LCBpY29uOiAiR29vZ2xlSWRlbnRpdHkiIH0KICAgIFtpYXBfYmFzdGlvbjogIklBUCBBZG1pbiBCYXN0aW9uIiB8ICJTaGllbGRlZCBWTSAoTm8gUHVibGljIElQKSJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE5NCwgaWNvbjogIkdjcENvbXB1dGUiIH0KICB9CgogIFpvbmUgQFpvbmUzX0NvbXB1dGUgewogICAgYXJlYTogInozIgogICAgdGl0bGU6ICIyLiBQcml2YXRlIENvbXB1dGUgUnVudGltZXMgKFZQQyBFZ3Jlc3MgJiBXb3JrbG9hZCBJZGVudGl0eSkiCiAgICBzdHlsZTogQEV4ZWN1dGlvblpvbmUKICAgIGxheW91dDogcm93LCBnYXA6IDM2LCBhbGlnbjogY2VudGVyLCBqdXN0aWZ5OiBjZW50ZXIKCiAgICBbdnBjX3JvdXRlcl9uYXQ6ICJQcml2YXRlIEFJIFZQQ1xuJiBDbG91ZCBOQVQiIHwgIkRpcmVjdCBWUEMgRWdyZXNzIC8gUFNBIl0gewogICAgICBzdHlsZTogQEdhdGV3YXlIdWJDYXJkLCBpY29uOiAiVmlydHVhbFByaXZhdGVDbG91ZCIsCiAgICAgIGRlc2NyaXB0aW9uOiAiQ3VzdG9tIFZQQyB3aXRoIFByaXZhdGUgR29vZ2xlIEFjY2VzcywgUHJpdmF0ZSBTZXJ2aWNlIENvbm5lY3QsIGFuZCBDbG91ZCBOQVQiCiAgICB9CgogICAgWm9uZSBAQ29tcHV0ZVByb2ZpbGVzQ29sIHsKICAgICAgc3R5bGU6IEBHaG9zdCwgbGF5b3V0OiBjb2x1bW4sIGdhcDogMTQsIGFsaWduOiBzdHJldGNoCgogICAgICBab25lIEBTZXJ2ZXJsZXNzUHJvZmlsZSB7CiAgICAgICAgdGl0bGU6ICJQcm9maWxlIEE6IFNlcnZlcmxlc3MgQ29tcHV0ZSAoZW5hYmxlX2Nsb3VkcnVuKSIKICAgICAgICBzdHlsZTogQFBlYWNoU3ViR3JvdXAsIHdpZHRoOiAzNDQsIGxheW91dDogcm93LCBnYXA6IDEwLCBhbGlnbjogY2VudGVyLCBqdXN0aWZ5OiBjZW50ZXIKICAgICAgICBbY2xvdWRfcnVuX3YyOiAiQ2xvdWQgUnVuIHYyIiB8ICJEaXJlY3QgVlBDIEVncmVzcyJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE1NCwgaWNvbjogIkdjcENsb3VkUnVuIiB9CiAgICAgICAgW2FydGlmYWN0X3JlZzogIkFydGlmYWN0IFJlZ2lzdHJ5IiB8ICJDb250YWluZXIgSW1hZ2VzIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTU0LCBpY29uOiAiQXJ0aWZhY3RSZWdpc3RyeSIgfQogICAgICB9CgogICAgICBab25lIEBLdWJlcm5ldGVzUHJvZmlsZSB7CiAgICAgICAgdGl0bGU6ICJQcm9maWxlIEI6IEVudGVycHJpc2UgSzhzIChlbmFibGVfZ2tlKSIKICAgICAgICBzdHlsZTogQFBlYWNoU3ViR3JvdXAsIGRhc2hlZDogdHJ1ZSwgd2lkdGg6IDM0NCwgbGF5b3V0OiByb3csIGdhcDogMTAsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICAgIFtna2VfYXV0b3BpbG90OiAiR0tFIEF1dG9waWxvdCIgfCAiUHJpdmF0ZSBOb2RlcyArIFdJIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTU0LCBpY29uOiAiR0tFIiB9CiAgICAgICAgW3dvcmtsb2FkX2lkOiAiV29ya2xvYWQgSWRlbnRpdHkiIHwgIktleWxlc3MgT0lEQyBJQU0iXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNTQsIGljb246ICJHY3BMb2NrIiB9CiAgICAgIH0KICAgIH0KICB9CgogIFpvbmUgQFpvbmUyX0dvdmVybmFuY2UgewogICAgYXJlYTogInoyIgogICAgdGl0bGU6ICIzLiBTZWN1cml0eSwgRmluT3BzLCBPYnNlcnZhYmlsaXR5ICYgQWdlbnRpYyBHYXRla2VlcGVyIgogICAgc3R5bGU6IEBHb3Zlcm5hbmNlWm9uZQogICAgbGF5b3V0OiByb3csIGdhcDogMjQsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgoKICAgIFpvbmUgQFNyZUFuZEZpbm9wc0NvbCB7CiAgICAgIHN0eWxlOiBAR2hvc3QsIGxheW91dDogY29sdW1uLCBnYXA6IDEyLCBhbGlnbjogY2VudGVyCiAgICAgIFtjbG91ZF9tb25pdG9yaW5nOiAiQ2xvdWQgTW9uaXRvcmluZyIgfCAiU0xPcyAmIExhdGVuY3kgQWxlcnRzIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTgyLCBpY29uOiAiQ2xvdWRNb25pdG9yaW5nIiB9CiAgICAgIFtjbG91ZF9sb2dnaW5nOiAiQ2xvdWQgTG9nZ2luZyIgfCAiQXVkaXQgU2luayB0byBCaWdRdWVyeSJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE4MiwgaWNvbjogIkNsb3VkTG9nZ2luZyIgfQogICAgICBbZmlub3BzX2J1ZGdldDogIkNsb3VkIEJpbGxpbmcgRmluT3BzIiB8ICJBbGVydHMgNTAlIC8gOTAlIC8gMTAwJSJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE4MiwgaWNvbjogIkNsb3VkQmlsbGluZyIgfQogICAgfQoKICAgIFpvbmUgQFNvdmVyZWlnbkd1YXJkcmFpbHMgewogICAgICB0aXRsZTogIlNvdmVyZWlnbiBDb250cm9scyAmIE0xTDEgR2F0ZWtlZXBlciIKICAgICAgc3R5bGU6IEBHcmVlblN1Ykdyb3VwLCBsYXlvdXQ6IGNvbHVtbiwgZ2FwOiA4LCBhbGlnbjogY2VudGVyCiAgICAgIFtndWFyZF9pYW06ICJSZXNvdXJjZS1TY29wZWQgSUFNIE9ubHkiXSB7IHN0eWxlOiBAUG9saWN5UGlsbCwgaWNvbjogIlNoaWVsZENoZWNrIiB9CiAgICAgIFtndWFyZF9jbWVrOiAiQ2xvdWQgS01TIENNRUsgKDkwZCBSb3RhdGlvbikiXSB7IHN0eWxlOiBAUG9saWN5UGlsbCwgaWNvbjogIktNUyIgfQogICAgICBbZ3VhcmRfd29ybTogIldPUk0gQmFja3VwIExvY2sgKGVuZm9yY2U9dHJ1ZSkiXSB7IHN0eWxlOiBAUG9saWN5UGlsbCwgaWNvbjogIkxvY2siIH0KICAgICAgW2d1YXJkX20xbDE6ICJNMUwxIHZlcmlmeS5zaCAmIFN1YmFnZW50cyJdIHsgc3R5bGU6IEBQb2xpY3lQaWxsLCBpY29uOiAiQm90IiB9CiAgICB9CiAgfQoKICBab25lIEBab25lNF9EYXRhQUkgewogICAgYXJlYTogIno0IgogICAgdGl0bGU6ICI0LiBEYXRhIExha2Vob3VzZSwgVmVydGV4IEFJICYgSW1tdXRhYmxlIFJlc2lsaWVuY2UgKG1vZHVsZXMvZGF0YS1haS1mb3VuZGF0aW9uICYgYmFja3VwLWRyKSIKICAgIHN0eWxlOiBAUmVzb3VyY2Vab25lCiAgICBsYXlvdXQ6IG1hdHJpeCwgY29sczogMywgc2l6ZXM6IFsiMS4wNWZyIiwgIjEuMTVmciIsICIwLjk1ZnIiXSwgZ2FwOiAxOCwgYWxpZ246IGNlbnRlcgoKICAgIFpvbmUgQFN0b3JhZ2VBbmRMYWtlaG91c2UgewogICAgICB0aXRsZTogIkVuY3J5cHRlZCBEYXRhICYgQ29ycHVzIFN0b3JhZ2UiCiAgICAgIHN0eWxlOiBAQW1iZXJTdWJHcm91cCwgbGF5b3V0OiByb3csIGdhcDogMTIsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICBbZ2NzX3JhZ19idWNrZXQ6ICJDbG91ZCBTdG9yYWdlIiB8ICJVQkxBICsgVmVyc2lvbmluZyJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE2OCwgaWNvbjogIkdjcFN0b3JhZ2VCdWNrZXQiIH0KICAgICAgW2JpZ3F1ZXJ5X2xha2U6ICJCaWdRdWVyeSBMYWtlaG91c2UiIHwgIlBhcnRpdGlvbmVkIEFuYWx5dGljcyJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE3NCwgaWNvbjogIkJpZ1F1ZXJ5IiB9CiAgICB9CgogICAgWm9uZSBAVmVydGV4QWlQbGF0Zm9ybSB7CiAgICAgIHRpdGxlOiAiTWFuYWdlZCBHZW5BSSAmIEVtYmVkZGluZ3MgKGV1cm9wZS13ZXN0MSkiCiAgICAgIHN0eWxlOiBAQW1iZXJTdWJHcm91cCwgbGF5b3V0OiByb3csIGdhcDogMTIsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICBbdmVydGV4X2dlbWluaTogIlZlcnRleCBBSSBHZW1pbmkiIHwgIkdlbWluaSAzLjUgRmxhc2ggLyBQcm8iXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNzYsIGljb246ICJWZXJ0ZXhBSSIgfQogICAgICBbdmVydGV4X2VtYmVkOiAiVmVydGV4IEVtYmVkZGluZ3MiIHwgInRleHQtZW1iZWRkaW5nLTAwNCAoNzY4ZCkiXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxODQsIGljb246ICJBSVBsYXRmb3JtIiB9CiAgICB9CgogICAgWm9uZSBAUmVzaWxpZW5jZUFuZEttcyB7CiAgICAgIHRpdGxlOiAiQ3J5cHRvICYgRGlzYXN0ZXIgUmVjb3ZlcnkiCiAgICAgIHN0eWxlOiBAQW1iZXJTdWJHcm91cCwgbGF5b3V0OiByb3csIGdhcDogMTIsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICBbY2xvdWRfa21zOiAiQ2xvdWQgS01TIENNRUsiIHwgIjkwLURheSBLZXkgUm90YXRpb24iXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNjgsIGljb246ICJLTVMiIH0KICAgICAgW2JhY2t1cF9kcl93b3JtOiAiQmFja3VwICYgRFIgVmF1bHQiIHwgIkltbXV0YWJsZSBXT1JNIExvY2siXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNzQsIGljb246ICJTZWN1cml0eUNvbW1hbmRDZW50ZXIiIH0KICAgIH0KICB9Cn0KCltlbnRlcnByaXNlX3VzZXJzXSAtLT4gW2Nsb3VkX2FybW9yX3dhZl0geyBjb2xvcjogJEdjcEJsdWUsIHN0cm9rZVdpZHRoOiAyLCBzb3VyY2VBbmNob3I6ICJyaWdodCIsIHRhcmdldEFuY2hvcjogImxlZnQiLCBjdXJ2ZTogInN0ZXAiLCBzZXF1ZW5jZUJhZGdlOiAiMSIsIGJhZGdlRmlsbDogJEdjcEJsdWUsIGJhZGdlRm9udENvbG9yOiAkU3VyZmFjZVdoaXRlIH0KW2Nsb3VkX2FybW9yX3dhZl0gLS0+IFtnbG9iYWxfbGJdIHsgY29sb3I6ICRHY3BCbHVlLCBzdHJva2VXaWR0aDogMiwgc291cmNlQW5jaG9yOiAicmlnaHQiLCB0YXJnZXRBbmNob3I6ICJsZWZ0IiwgY3VydmU6ICJzdGVwIiB9CltnbG9iYWxfbGJdIC0tPiBbaWFwX3Byb3h5XSB7IGNvbG9yOiAkR2NwQmx1ZSwgc3Ryb2tlV2lkdGg6IDIsIHNvdXJjZUFuY2hvcjogInJpZ2h0IiwgdGFyZ2V0QW5jaG9yOiAibGVmdCIsIGN1cnZlOiAic3RlcCIgfQpbWm9uZTFfUGVyaW1ldGVyXSAtLT4gW3ZwY19yb3V0ZXJfbmF0XSB7IGNvbG9yOiAkR2NwQmx1ZSwgc3Ryb2tlV2lkdGg6IDIsIHNvdXJjZUFuY2hvcjogImJvdHRvbSIsIHRhcmdldEFuY2hvcjogInRvcCIsIGN1cnZlOiAic3RlcCIsIGxhYmVsOiAiWmVyby1UcnVzdCIsIHNlcXVlbmNlQmFkZ2U6ICIyIiwgYmFkZ2VGaWxsOiAkR2NwQmx1ZSwgYmFkZ2VGb250Q29sb3I6ICRTdXJmYWNlV2hpdGUgfQpbdnBjX3JvdXRlcl9uYXRdIC0tPiBbU2VydmVybGVzc1Byb2ZpbGVdIHsgY29sb3I6ICRHY3BCbHVlLCBzdHJva2VXaWR0aDogMiwgc291cmNlQW5jaG9yOiAicmlnaHQiLCB0YXJnZXRBbmNob3I6ICJsZWZ0IiwgY3VydmU6ICJzdGVwIiB9Clt2cGNfcm91dGVyX25hdF0gLS0+IFtLdWJlcm5ldGVzUHJvZmlsZV0geyBjb2xvcjogJEdjcEJsdWUsIHN0cm9rZVdpZHRoOiAyLCBzb3VyY2VBbmNob3I6ICJyaWdodCIsIHRhcmdldEFuY2hvcjogImxlZnQiLCBjdXJ2ZTogInN0ZXAiIH0KW0NvbXB1dGVQcm9maWxlc0NvbF0gLS0+IFtTcmVBbmRGaW5vcHNDb2xdIHsgY29sb3I6ICRCdXNTdHJva2UsIHN0cm9rZVdpZHRoOiAxLjgsIGRhc2hlZDogdHJ1ZSwgc291cmNlQW5jaG9yOiAicmlnaHQiLCB0YXJnZXRBbmNob3I6ICJsZWZ0IiwgY3VydmU6ICJzdGVwIiwgbGFiZWw6ICJUZWxlbWV0cnkiIH0KW1NyZUFuZEZpbm9wc0NvbF0gLS0+IFtTb3ZlcmVpZ25HdWFyZHJhaWxzXSB7IGNvbG9yOiAkR2NwR3JlZW4sIHN0cm9rZVdpZHRoOiAxLjgsIHNvdXJjZUFuY2hvcjogInJpZ2h0IiwgdGFyZ2V0QW5jaG9yOiAibGVmdCIsIGN1cnZlOiAic3RlcCIgfQpbWm9uZTNfQ29tcHV0ZV0gLS0+IFtTdG9yYWdlQW5kTGFrZWhvdXNlXSB7IGNvbG9yOiAkRW1lcmFsZFRlYWwsIHN0cm9rZVdpZHRoOiAyLCBzb3VyY2VBbmNob3I6ICJib3R0b20iLCB0YXJnZXRBbmNob3I6ICJ0b3AiLCBjdXJ2ZTogInN0ZXAiLCBsYWJlbDogIlN0b3JhZ2UgQVBJIiwgc2VxdWVuY2VCYWRnZTogIjMiLCBiYWRnZUZpbGw6ICRFbWVyYWxkVGVhbCwgYmFkZ2VGb250Q29sb3I6ICRTdXJmYWNlV2hpdGUgfQpbWm9uZTNfQ29tcHV0ZV0gLS0+IFtWZXJ0ZXhBaVBsYXRmb3JtXSB7IGNvbG9yOiAkR2NwQmx1ZSwgc3Ryb2tlV2lkdGg6IDIsIHNvdXJjZUFuY2hvcjogImJvdHRvbSIsIHRhcmdldEFuY2hvcjogInRvcCIsIGN1cnZlOiAic3RlcCIsIGxhYmVsOiAiVmVydGV4IEFEQyIsIHNlcXVlbmNlQmFkZ2U6ICI0IiwgYmFkZ2VGaWxsOiAkR2NwQmx1ZSwgYmFkZ2VGb250Q29sb3I6ICRTdXJmYWNlV2hpdGUgfQpbWm9uZTJfR292ZXJuYW5jZV0gLS0+IFtSZXNpbGllbmNlQW5kS21zXSB7IGNvbG9yOiAkR2NwR3JlZW4sIHN0cm9rZVdpZHRoOiAxLjgsIGRhc2hlZDogdHJ1ZSwgc291cmNlQW5jaG9yOiAiYm90dG9tIiwgdGFyZ2V0QW5jaG9yOiAidG9wIiwgY3VydmU6ICJzdGVwIiwgbGFiZWw6ICJDTUVLICYgV09STSIgfQo=) | Visualisation interactive plein écran, zoom vectoriel, export PNG/SVG/Draw.io en 1 clic |
| **📐 Source Dendrite v3.3 (`.dendrite`)** | [`docs/diagrams/foundation_blueprint_v3.dendrite`](diagrams/foundation_blueprint_v3.dendrite) | Code source déclaratif YAML/DSL Dendrite v3.3 (grille Bento 16:9, icônes GCP officielles) |
| **🧩 Export Draw.io / Diagrams.net (`.drawio`)** | [`docs/diagrams/foundation_blueprint_v3.drawio`](diagrams/foundation_blueprint_v3.drawio) | Fichier XML natif importable dans **Draw.io**, **Lucidchart** ou **Google Slides** |

---

## 1. Spécification Dendrite v3.3 (`docs/diagrams/foundation_blueprint_v3.dendrite`)

> **Sous-titre exécutif** : *9 Modules Terraform Production-Ready, Cloud Armor WAF, Direct VPC Egress, GKE Autopilot, Vertex AI, KMS CMEK & Backup DR*

Pour re-compiler ce schéma en local ou vérifier les contraintes géométriques (0 overlap, 0 clipping) :
```bash
node /google/src/files/head/depot/google3/cloud/professional_services/agents/skills/dendrite/scripts/render_dendrite.mjs \
  docs/diagrams/foundation_blueprint_v3.dendrite
```

```yaml
renderOrder: nodes-first
direction: down

const GcpBlue = "#1a73e8"
const GcpGreen = "#1e8e3e"
const EmeraldTeal = "#0d9488"
const DarkSlate = "#202124"
const SubText = "#5f6368"
const CardBorder = "#dadce0"
const BusStroke = "#334155"
const SurfaceWhite = "#ffffff"

Style @Ghost {
  fill: transparent, strokeWidth: 0, fontColor: transparent, padding: 0
}
Style @ArchitectureRoot {
  fill: "#f8fafd", strokeColor: "#c2d7f5", strokeWidth: 1.5, borderRadius: 16,
  padding: 22, gap: 18, fontColor: "#3c4043", fontSize: 22, labelWeight: bold,
  icon: "GoogleCloud", iconSize: 28
}
Style @PerimeterZone {
  fill: "#e8f0fe", strokeColor: "#8ab4f8", strokeWidth: 1.5, borderRadius: 12,
  padding: 16, gap: 16, fontColor: $DarkSlate, fontSize: 15, labelWeight: bold
}
Style @ExecutionZone {
  fill: "#fce8e6", strokeColor: "#f6aea9", strokeWidth: 1.5, borderRadius: 12,
  padding: 16, gap: 16, fontColor: $DarkSlate, fontSize: 15, labelWeight: bold
}
Style @GovernanceZone {
  fill: "#e6f4ea", strokeColor: "#81c995", strokeWidth: 1.5, borderRadius: 12,
  padding: 16, gap: 14, fontColor: $DarkSlate, fontSize: 15, labelWeight: bold
}
Style @ResourceZone {
  fill: "#fef7e0", strokeColor: "#fde293", strokeWidth: 1.5, borderRadius: 12,
  padding: 16, gap: 16, fontColor: $DarkSlate, fontSize: 15, labelWeight: bold
}
Style @PeachSubGroup {
  fill: "#f8d3c8", strokeColor: darken("#f8d3c8", 12), strokeWidth: 1, borderRadius: 10,
  padding: 12, gap: 10, fontColor: $DarkSlate, fontSize: 13, labelWeight: bold
}
Style @GreenSubGroup {
  fill: "#ceead6", strokeColor: darken("#ceead6", 14), strokeWidth: 1, borderRadius: 10,
  padding: 10, gap: 7, fontColor: $DarkSlate, fontSize: 13, labelWeight: bold
}
Style @AmberSubGroup {
  fill: "#f9e4a7", strokeColor: darken("#f9e4a7", 14), strokeWidth: 1, borderRadius: 10,
  padding: 12, gap: 12, fontColor: $DarkSlate, fontSize: 13, labelWeight: bold
}
Style @ActorCard {
  width: 180, height: 56,
  fill: $SurfaceWhite, strokeColor: $CardBorder, strokeWidth: 1, borderRadius: 8,
  fontColor: $DarkSlate, subFontColor: $SubText,
  fontSize: 14, subFontSize: 11, labelWeight: bold,
  textAlign: "left", textVAlign: "middle",
  iconPosition: "left", iconSize: 28, padding: 10, shadow: true
}
Style @ProductCard {
  width: 168, height: 58,
  fill: $SurfaceWhite, strokeColor: $CardBorder, strokeWidth: 1, borderRadius: 8,
  fontColor: $DarkSlate, subFontColor: $SubText,
  fontSize: 13.5, subFontSize: 11, labelWeight: bold,
  textAlign: "left", textVAlign: "middle",
  iconPosition: "left", iconSize: 28, padding: 10, shadow: true
}
Style @GatewayHubCard {
  base: @ProductCard,
  width: 196, height: 66, strokeColor: $GcpBlue, strokeWidth: 2,
  fontSize: 14.5, subFontSize: 11, iconSize: 30, padding: 12
}
Style @PolicyPill {
  width: 228, height: 32,
  fill: $SurfaceWhite, strokeColor: "#9aa0a6", strokeWidth: 1, borderRadius: 16,
  fontColor: $DarkSlate, fontSize: 12.5, labelWeight: bold,
  textAlign: "left", textVAlign: "middle",
  iconPosition: "left", iconSize: 16, padding: 10, shadow: true
}

Zone @GCP_AI_Foundation_Blueprint {
  title: "GCP AI Foundation Blueprint — Enterprise Landing Zone (europe-west1)"
  style: @ArchitectureRoot
  layout: matrix
  areas: [
    "z1 z1 z1 z1 z1",
    "z3 z3 z2 z2 z2",
    "z4 z4 z4 z4 z4"
  ]
  sizes: ["1.05fr", "1.05fr", "0.96fr", "0.96fr", "0.96fr"]
  gap: 20

  Zone @Zone1_Perimeter {
    area: "z1"
    title: "1. Zero-Trust Edge Perimeter & Ingress (modules/security-waf & networking)"
    style: @PerimeterZone
    layout: row, gap: 18, align: center, justify: center
    [enterprise_users: "Enterprise Users" | "HTTPS Clients"] { style: @ActorCard, icon: "Users" }
    [cloud_armor_waf: "Cloud Armor WAF" | "OWASP Top 10 & DDoS"] { style: @ProductCard, width: 186, icon: "CloudArmor" }
    [global_lb: "Global HTTPS LB" | "Anycast & Managed SSL"] { style: @ProductCard, width: 186, icon: "CloudLoadBalancing" }
    [iap_proxy: "Identity-Aware Proxy" | "Zero-Trust OIDC Auth"] { style: @ProductCard, width: 188, icon: "GoogleIdentity" }
    [iap_bastion: "IAP Admin Bastion" | "Shielded VM (No Public IP)"] { style: @ProductCard, width: 194, icon: "GcpCompute" }
  }

  Zone @Zone3_Compute {
    area: "z3"
    title: "2. Private Compute Runtimes (VPC Egress & Workload Identity)"
    style: @ExecutionZone
    layout: row, gap: 36, align: center, justify: center

    [vpc_router_nat: "Private AI VPC\n& Cloud NAT" | "Direct VPC Egress / PSA"] {
      style: @GatewayHubCard, icon: "VirtualPrivateCloud",
      description: "Custom VPC with Private Google Access, Private Service Connect, and Cloud NAT"
    }

    Zone @ComputeProfilesCol {
      style: @Ghost, layout: column, gap: 14, align: stretch

      Zone @ServerlessProfile {
        title: "Profile A: Serverless Compute (enable_cloudrun)"
        style: @PeachSubGroup, width: 344, layout: row, gap: 10, align: center, justify: center
        [cloud_run_v2: "Cloud Run v2" | "Direct VPC Egress"] { style: @ProductCard, width: 154, icon: "GcpCloudRun" }
        [artifact_reg: "Artifact Registry" | "Container Images"] { style: @ProductCard, width: 154, icon: "ArtifactRegistry" }
      }

      Zone @KubernetesProfile {
        title: "Profile B: Enterprise K8s (enable_gke)"
        style: @PeachSubGroup, dashed: true, width: 344, layout: row, gap: 10, align: center, justify: center
        [gke_autopilot: "GKE Autopilot" | "Private Nodes + WI"] { style: @ProductCard, width: 154, icon: "GKE" }
        [workload_id: "Workload Identity" | "Keyless OIDC IAM"] { style: @ProductCard, width: 154, icon: "GcpLock" }
      }
    }
  }

  Zone @Zone2_Governance {
    area: "z2"
    title: "3. Security, FinOps, Observability & Agentic Gatekeeper"
    style: @GovernanceZone
    layout: row, gap: 24, align: center, justify: center

    Zone @SreAndFinopsCol {
      style: @Ghost, layout: column, gap: 12, align: center
      [cloud_monitoring: "Cloud Monitoring" | "SLOs & Latency Alerts"] { style: @ProductCard, width: 182, icon: "CloudMonitoring" }
      [cloud_logging: "Cloud Logging" | "Audit Sink to BigQuery"] { style: @ProductCard, width: 182, icon: "CloudLogging" }
      [finops_budget: "Cloud Billing FinOps" | "Alerts 50% / 90% / 100%"] { style: @ProductCard, width: 182, icon: "CloudBilling" }
    }

    Zone @SovereignGuardrails {
      title: "Sovereign Controls & M1L1 Gatekeeper"
      style: @GreenSubGroup, layout: column, gap: 8, align: center
      [guard_iam: "Resource-Scoped IAM Only"] { style: @PolicyPill, icon: "ShieldCheck" }
      [guard_cmek: "Cloud KMS CMEK (90d Rotation)"] { style: @PolicyPill, icon: "KMS" }
      [guard_worm: "WORM Backup Lock (enforce=true)"] { style: @PolicyPill, icon: "Lock" }
      [guard_m1l1: "M1L1 verify.sh & Subagents"] { style: @PolicyPill, icon: "Bot" }
    }
  }

  Zone @Zone4_DataAI {
    area: "z4"
    title: "4. Data Lakehouse, Vertex AI & Immutable Resilience (modules/data-ai-foundation & backup-dr)"
    style: @ResourceZone
    layout: matrix, cols: 3, sizes: ["1.05fr", "1.15fr", "0.95fr"], gap: 18, align: center

    Zone @StorageAndLakehouse {
      title: "Encrypted Data & Corpus Storage"
      style: @AmberSubGroup, layout: row, gap: 12, align: center, justify: center
      [gcs_rag_bucket: "Cloud Storage" | "UBLA + Versioning"] { style: @ProductCard, width: 168, icon: "GcpStorageBucket" }
      [bigquery_lake: "BigQuery Lakehouse" | "Partitioned Analytics"] { style: @ProductCard, width: 174, icon: "BigQuery" }
    }

    Zone @VertexAiPlatform {
      title: "Managed GenAI & Embeddings (europe-west1)"
      style: @AmberSubGroup, layout: row, gap: 12, align: center, justify: center
      [vertex_gemini: "Vertex AI Gemini" | "Gemini 3.5 Flash / Pro"] { style: @ProductCard, width: 176, icon: "VertexAI" }
      [vertex_embed: "Vertex Embeddings" | "text-embedding-004 (768d)"] { style: @ProductCard, width: 184, icon: "AIPlatform" }
    }

    Zone @ResilienceAndKms {
      title: "Crypto & Disaster Recovery"
      style: @AmberSubGroup, layout: row, gap: 12, align: center, justify: center
      [cloud_kms: "Cloud KMS CMEK" | "90-Day Key Rotation"] { style: @ProductCard, width: 168, icon: "KMS" }
      [backup_dr_worm: "Backup & DR Vault" | "Immutable WORM Lock"] { style: @ProductCard, width: 174, icon: "SecurityCommandCenter" }
    }
  }
}

[enterprise_users] --> [cloud_armor_waf] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "right", targetAnchor: "left", curve: "step", sequenceBadge: "1", badgeFill: $GcpBlue, badgeFontColor: $SurfaceWhite }
[cloud_armor_waf] --> [global_lb] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "right", targetAnchor: "left", curve: "step" }
[global_lb] --> [iap_proxy] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "right", targetAnchor: "left", curve: "step" }
[Zone1_Perimeter] --> [vpc_router_nat] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "bottom", targetAnchor: "top", curve: "step", label: "Zero-Trust", sequenceBadge: "2", badgeFill: $GcpBlue, badgeFontColor: $SurfaceWhite }
[vpc_router_nat] --> [ServerlessProfile] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "right", targetAnchor: "left", curve: "step" }
[vpc_router_nat] --> [KubernetesProfile] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "right", targetAnchor: "left", curve: "step" }
[ComputeProfilesCol] --> [SreAndFinopsCol] { color: $BusStroke, strokeWidth: 1.8, dashed: true, sourceAnchor: "right", targetAnchor: "left", curve: "step", label: "Telemetry" }
[SreAndFinopsCol] --> [SovereignGuardrails] { color: $GcpGreen, strokeWidth: 1.8, sourceAnchor: "right", targetAnchor: "left", curve: "step" }
[Zone3_Compute] --> [StorageAndLakehouse] { color: $EmeraldTeal, strokeWidth: 2, sourceAnchor: "bottom", targetAnchor: "top", curve: "step", label: "Storage API", sequenceBadge: "3", badgeFill: $EmeraldTeal, badgeFontColor: $SurfaceWhite }
[Zone3_Compute] --> [VertexAiPlatform] { color: $GcpBlue, strokeWidth: 2, sourceAnchor: "bottom", targetAnchor: "top", curve: "step", label: "Vertex ADC", sequenceBadge: "4", badgeFill: $GcpBlue, badgeFontColor: $SurfaceWhite }
[Zone2_Governance] --> [ResilienceAndKms] { color: $GcpGreen, strokeWidth: 1.8, dashed: true, sourceAnchor: "bottom", targetAnchor: "top", curve: "step", label: "CMEK & WORM" }
```

---

## 2. Spécification GCP Draw (`go/gcpdraw`)

### 📋 Instructions d'utilisation
1. Rendez-vous sur l'outil officiel Google Cloud : **[GCP Draw (go/gcpdraw)](https://gcpdraw.corp.google.com)**.
2. Cliquez sur **Import / Code**.
3. Copiez-collez l'intégralité du bloc ci-dessous pour visualiser, éditer et exporter le schéma.

```text
meta {
  title "GCP AI Foundation Blueprint — Sovereign AI Landing Zone (v3.3)"
}

elements {
  card users as users {
    display_name "Enterprise Users & SREs"
  }

  gcp {
    card armor as waf {
      name "Cloud Armor WAF"
      description "OWASP Top 10 (XSS/SQLi/LFI/RFI) & Adaptive DDoS"
    }

    card load_balancer as lb {
      name "Global HTTP(S) Load Balancer"
      description "Anycast IP, Managed SSL & Traffic Routing"
    }

    card iap as iap {
      name "Identity-Aware Proxy (IAP)"
      description "Zero-Trust Admin & SSH Bastion Tunneling"
    }

    group vpc_network {
      name "VPC Foundation (10.0.0.0/16) & Private Service Access"

      card run as cloud_run {
        name "Cloud Run Gen2"
        description "Direct VPC Egress (PRIVATE_RANGES_only) & Serverless AI"
      }

      card gke as gke_autopilot {
        name "GKE Autopilot Private Cluster"
        description "Multi-Zone AI Swarm & Workload Identity"
      }

      card compute_engine as bastion {
        name "Shielded Bastion VM (e2-micro)"
        description "No Public IP — IAP Tunneling Only"
      }

      card nat as cloud_nat {
        name "Cloud Router & Cloud NAT"
        description "Outbound Gateway Without Public IPs"
      }
    }

    group data_ai {
      name "Sovereign Data & Vertex AI Foundation (CMEK Protected)"

      card kms as cloud_kms {
        name "Cloud KMS (CMEK)"
        description "90-Day Automatic Key Rotation"
      }

      card storage as rag_storage {
        name "Cloud Storage (GCS)"
        description "RAG Corpus & Versioned Artifacts"
      }

      card bigquery as bq_lakehouse {
        name "BigQuery Lakehouse"
        description "Vector Store, M57 Analytics & Log Sink"
      }

      card vertex_ai as vertex_ai {
        name "Vertex AI Platform"
        description "Gemini 2.5 Flash/Pro & text-embedding-004"
      }
    }

    group ops {
      name "Observability, FinOps & Disaster Recovery"

      card monitoring as monitoring {
        name "Cloud Monitoring & Logging"
        description "SLO Alerts & Schema Drift Shield Sink"
      }

      card billing as finops {
        name "Cloud Billing Budgets"
        description "50% / 90% / 100% FinOps Thresholds"
      }

      card backup_and_dr as backup_dr {
        name "Backup & DR Service"
        description "Immutable Multi-Region WORM Vaults"
      }
    }
  }
}

paths {
  users -down-> waf
  waf --> lb
  lb --> iap
  iap -down-> cloud_run
  iap -down-> gke_autopilot
  iap -down-> bastion

  cloud_run --> rag_storage : "Direct VPC Egress"
  cloud_run --> bq_lakehouse : "Analytics"
  cloud_run --> vertex_ai : "Gemini & Embeddings"

  gke_autopilot --> bq_lakehouse : "Workload Identity"
  gke_autopilot --> vertex_ai : "ADK 2.0 Swarm"
  bastion --> gke_autopilot : "Private Control Plane (172.16.0.0/28)"

  rag_storage ..> cloud_kms : "CMEK"
  bq_lakehouse ..> cloud_kms : "CMEK"
  gke_autopilot ..> cloud_nat : "Egress"
  cloud_run ..> monitoring : "Telemetry & Audit"
  gke_autopilot ..> backup_dr : "Stateful Vaulting"
}
```
