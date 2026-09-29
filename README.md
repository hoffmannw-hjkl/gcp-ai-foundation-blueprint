> 🇫🇷 **[Version Française](README.md)** | 🇬🇧 **[English Version](README-EN.md)** | 🎬 **[Guide de Démo Pas-à-Pas (DEMO_PLAYBOOK.md)](docs/DEMO_PLAYBOOK.md)** | 🗺️ **[Schémas Dendrite v3.3 & Draw.io](docs/architecture-gcpdraw.md)**

> 🗺️ **Schémas d'Architecture Exécutifs (Dendrite v3.3 Bento 16:9 & Draw.io)** : [**🎨 Ouvrir dans Dendrite Studio (1-Click) ↗**](https://dendrite-758054785671.cr.gclb.goog/#code=cmVuZGVyT3JkZXI6IG5vZGVzLWZpcnN0CmRpcmVjdGlvbjogZG93bgoKY29uc3QgR2NwQmx1ZSA9ICIjMWE3M2U4Igpjb25zdCBHY3BHcmVlbiA9ICIjMWU4ZTNlIgpjb25zdCBFbWVyYWxkVGVhbCA9ICIjMGQ5NDg4Igpjb25zdCBEYXJrU2xhdGUgPSAiIzIwMjEyNCIKY29uc3QgU3ViVGV4dCA9ICIjNWY2MzY4Igpjb25zdCBDYXJkQm9yZGVyID0gIiNkYWRjZTAiCmNvbnN0IEJ1c1N0cm9rZSA9ICIjMzM0MTU1Igpjb25zdCBTdXJmYWNlV2hpdGUgPSAiI2ZmZmZmZiIKClN0eWxlIEBHaG9zdCB7CiAgZmlsbDogdHJhbnNwYXJlbnQsIHN0cm9rZVdpZHRoOiAwLCBmb250Q29sb3I6IHRyYW5zcGFyZW50LCBwYWRkaW5nOiAwCn0KU3R5bGUgQEFyY2hpdGVjdHVyZVJvb3QgewogIGZpbGw6ICIjZjhmYWZkIiwgc3Ryb2tlQ29sb3I6ICIjYzJkN2Y1Iiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxNiwKICBwYWRkaW5nOiAyMiwgZ2FwOiAxOCwgZm9udENvbG9yOiAiIzNjNDA0MyIsIGZvbnRTaXplOiAyMiwgbGFiZWxXZWlnaHQ6IGJvbGQsCiAgaWNvbjogIkdvb2dsZUNsb3VkIiwgaWNvblNpemU6IDI4Cn0KU3R5bGUgQFBlcmltZXRlclpvbmUgewogIGZpbGw6ICIjZThmMGZlIiwgc3Ryb2tlQ29sb3I6ICIjOGFiNGY4Iiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxMiwKICBwYWRkaW5nOiAxNiwgZ2FwOiAxNiwgZm9udENvbG9yOiAkRGFya1NsYXRlLCBmb250U2l6ZTogMTUsIGxhYmVsV2VpZ2h0OiBib2xkCn0KU3R5bGUgQEV4ZWN1dGlvblpvbmUgewogIGZpbGw6ICIjZmNlOGU2Iiwgc3Ryb2tlQ29sb3I6ICIjZjZhZWE5Iiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxMiwKICBwYWRkaW5nOiAxNiwgZ2FwOiAxNiwgZm9udENvbG9yOiAkRGFya1NsYXRlLCBmb250U2l6ZTogMTUsIGxhYmVsV2VpZ2h0OiBib2xkCn0KU3R5bGUgQEdvdmVybmFuY2Vab25lIHsKICBmaWxsOiAiI2U2ZjRlYSIsIHN0cm9rZUNvbG9yOiAiIzgxYzk5NSIsIHN0cm9rZVdpZHRoOiAxLjUsIGJvcmRlclJhZGl1czogMTIsCiAgcGFkZGluZzogMTYsIGdhcDogMTQsIGZvbnRDb2xvcjogJERhcmtTbGF0ZSwgZm9udFNpemU6IDE1LCBsYWJlbFdlaWdodDogYm9sZAp9ClN0eWxlIEBSZXNvdXJjZVpvbmUgewogIGZpbGw6ICIjZmVmN2UwIiwgc3Ryb2tlQ29sb3I6ICIjZmRlMjkzIiwgc3Ryb2tlV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxMiwKICBwYWRkaW5nOiAxNiwgZ2FwOiAxNiwgZm9udENvbG9yOiAkRGFya1NsYXRlLCBmb250U2l6ZTogMTUsIGxhYmVsV2VpZ2h0OiBib2xkCn0KU3R5bGUgQFBlYWNoU3ViR3JvdXAgewogIGZpbGw6ICIjZjhkM2M4Iiwgc3Ryb2tlQ29sb3I6IGRhcmtlbigiI2Y4ZDNjOCIsIDEyKSwgc3Ryb2tlV2lkdGg6IDEsIGJvcmRlclJhZGl1czogMTAsCiAgcGFkZGluZzogMTIsIGdhcDogMTAsIGZvbnRDb2xvcjogJERhcmtTbGF0ZSwgZm9udFNpemU6IDEzLCBsYWJlbFdlaWdodDogYm9sZAp9ClN0eWxlIEBHcmVlblN1Ykdyb3VwIHsKICBmaWxsOiAiI2NlZWFkNiIsIHN0cm9rZUNvbG9yOiBkYXJrZW4oIiNjZWVhZDYiLCAxNCksIHN0cm9rZVdpZHRoOiAxLCBib3JkZXJSYWRpdXM6IDEwLAogIHBhZGRpbmc6IDEwLCBnYXA6IDcsIGZvbnRDb2xvcjogJERhcmtTbGF0ZSwgZm9udFNpemU6IDEzLCBsYWJlbFdlaWdodDogYm9sZAp9ClN0eWxlIEBBbWJlclN1Ykdyb3VwIHsKICBmaWxsOiAiI2Y5ZTRhNyIsIHN0cm9rZUNvbG9yOiBkYXJrZW4oIiNmOWU0YTciLCAxNCksIHN0cm9rZVdpZHRoOiAxLCBib3JkZXJSYWRpdXM6IDEwLAogIHBhZGRpbmc6IDEyLCBnYXA6IDEyLCBmb250Q29sb3I6ICREYXJrU2xhdGUsIGZvbnRTaXplOiAxMywgbGFiZWxXZWlnaHQ6IGJvbGQKfQpTdHlsZSBAQWN0b3JDYXJkIHsKICB3aWR0aDogMTgwLCBoZWlnaHQ6IDU2LAogIGZpbGw6ICRTdXJmYWNlV2hpdGUsIHN0cm9rZUNvbG9yOiAkQ2FyZEJvcmRlciwgc3Ryb2tlV2lkdGg6IDEsIGJvcmRlclJhZGl1czogOCwKICBmb250Q29sb3I6ICREYXJrU2xhdGUsIHN1YkZvbnRDb2xvcjogJFN1YlRleHQsCiAgZm9udFNpemU6IDE0LCBzdWJGb250U2l6ZTogMTEsIGxhYmVsV2VpZ2h0OiBib2xkLAogIHRleHRBbGlnbjogImxlZnQiLCB0ZXh0VkFsaWduOiAibWlkZGxlIiwKICBpY29uUG9zaXRpb246ICJsZWZ0IiwgaWNvblNpemU6IDI4LCBwYWRkaW5nOiAxMCwgc2hhZG93OiB0cnVlCn0KU3R5bGUgQFByb2R1Y3RDYXJkIHsKICB3aWR0aDogMTY4LCBoZWlnaHQ6IDU4LAogIGZpbGw6ICRTdXJmYWNlV2hpdGUsIHN0cm9rZUNvbG9yOiAkQ2FyZEJvcmRlciwgc3Ryb2tlV2lkdGg6IDEsIGJvcmRlclJhZGl1czogOCwKICBmb250Q29sb3I6ICREYXJrU2xhdGUsIHN1YkZvbnRDb2xvcjogJFN1YlRleHQsCiAgZm9udFNpemU6IDEzLjUsIHN1YkZvbnRTaXplOiAxMSwgbGFiZWxXZWlnaHQ6IGJvbGQsCiAgdGV4dEFsaWduOiAibGVmdCIsIHRleHRWQWxpZ246ICJtaWRkbGUiLAogIGljb25Qb3NpdGlvbjogImxlZnQiLCBpY29uU2l6ZTogMjgsIHBhZGRpbmc6IDEwLCBzaGFkb3c6IHRydWUKfQpTdHlsZSBAR2F0ZXdheUh1YkNhcmQgewogIGJhc2U6IEBQcm9kdWN0Q2FyZCwKICB3aWR0aDogMTk2LCBoZWlnaHQ6IDY2LCBzdHJva2VDb2xvcjogJEdjcEJsdWUsIHN0cm9rZVdpZHRoOiAyLAogIGZvbnRTaXplOiAxNC41LCBzdWJGb250U2l6ZTogMTEsIGljb25TaXplOiAzMCwgcGFkZGluZzogMTIKfQpTdHlsZSBAUG9saWN5UGlsbCB7CiAgd2lkdGg6IDIyOCwgaGVpZ2h0OiAzMiwKICBmaWxsOiAkU3VyZmFjZVdoaXRlLCBzdHJva2VDb2xvcjogIiM5YWEwYTYiLCBzdHJva2VXaWR0aDogMSwgYm9yZGVyUmFkaXVzOiAxNiwKICBmb250Q29sb3I6ICREYXJrU2xhdGUsIGZvbnRTaXplOiAxMi41LCBsYWJlbFdlaWdodDogYm9sZCwKICB0ZXh0QWxpZ246ICJsZWZ0IiwgdGV4dFZBbGlnbjogIm1pZGRsZSIsCiAgaWNvblBvc2l0aW9uOiAibGVmdCIsIGljb25TaXplOiAxNiwgcGFkZGluZzogMTAsIHNoYWRvdzogdHJ1ZQp9Cgpab25lIEBHQ1BfQUlfRm91bmRhdGlvbl9CbHVlcHJpbnQgewogIHRpdGxlOiAiR0NQIEFJIEZvdW5kYXRpb24gQmx1ZXByaW50IOKAlCBFbnRlcnByaXNlIExhbmRpbmcgWm9uZSAoZXVyb3BlLXdlc3QxKSIKICBzdHlsZTogQEFyY2hpdGVjdHVyZVJvb3QKICBsYXlvdXQ6IG1hdHJpeAogIGFyZWFzOiBbCiAgICAiejEgejEgejEgejEgejEiLAogICAgInozIHozIHoyIHoyIHoyIiwKICAgICJ6NCB6NCB6NCB6NCB6NCIKICBdCiAgc2l6ZXM6IFsiMS4wNWZyIiwgIjEuMDVmciIsICIwLjk2ZnIiLCAiMC45NmZyIiwgIjAuOTZmciJdCiAgZ2FwOiAyMAoKICBab25lIEBab25lMV9QZXJpbWV0ZXIgewogICAgYXJlYTogInoxIgogICAgdGl0bGU6ICIxLiBaZXJvLVRydXN0IEVkZ2UgUGVyaW1ldGVyICYgSW5ncmVzcyAobW9kdWxlcy9zZWN1cml0eS13YWYgJiBuZXR3b3JraW5nKSIKICAgIHN0eWxlOiBAUGVyaW1ldGVyWm9uZQogICAgbGF5b3V0OiByb3csIGdhcDogMTgsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgW2VudGVycHJpc2VfdXNlcnM6ICJFbnRlcnByaXNlIFVzZXJzIiB8ICJIVFRQUyBDbGllbnRzIl0geyBzdHlsZTogQEFjdG9yQ2FyZCwgaWNvbjogIlVzZXJzIiB9CiAgICBbY2xvdWRfYXJtb3Jfd2FmOiAiQ2xvdWQgQXJtb3IgV0FGIiB8ICJPV0FTUCBUb3AgMTAgJiBERG9TIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTg2LCBpY29uOiAiQ2xvdWRBcm1vciIgfQogICAgW2dsb2JhbF9sYjogIkdsb2JhbCBIVFRQUyBMQiIgfCAiQW55Y2FzdCAmIE1hbmFnZWQgU1NMIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTg2LCBpY29uOiAiQ2xvdWRMb2FkQmFsYW5jaW5nIiB9CiAgICBbaWFwX3Byb3h5OiAiSWRlbnRpdHktQXdhcmUgUHJveHkiIHwgIlplcm8tVHJ1c3QgT0lEQyBBdXRoIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTg4LCBpY29uOiAiR29vZ2xlSWRlbnRpdHkiIH0KICAgIFtpYXBfYmFzdGlvbjogIklBUCBBZG1pbiBCYXN0aW9uIiB8ICJTaGllbGRlZCBWTSAoTm8gUHVibGljIElQKSJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE5NCwgaWNvbjogIkdjcENvbXB1dGUiIH0KICB9CgogIFpvbmUgQFpvbmUzX0NvbXB1dGUgewogICAgYXJlYTogInozIgogICAgdGl0bGU6ICIyLiBQcml2YXRlIENvbXB1dGUgUnVudGltZXMgKFZQQyBFZ3Jlc3MgJiBXb3JrbG9hZCBJZGVudGl0eSkiCiAgICBzdHlsZTogQEV4ZWN1dGlvblpvbmUKICAgIGxheW91dDogcm93LCBnYXA6IDM2LCBhbGlnbjogY2VudGVyLCBqdXN0aWZ5OiBjZW50ZXIKCiAgICBbdnBjX3JvdXRlcl9uYXQ6ICJQcml2YXRlIEFJIFZQQ1xuJiBDbG91ZCBOQVQiIHwgIkRpcmVjdCBWUEMgRWdyZXNzIC8gUFNBIl0gewogICAgICBzdHlsZTogQEdhdGV3YXlIdWJDYXJkLCBpY29uOiAiVmlydHVhbFByaXZhdGVDbG91ZCIsCiAgICAgIGRlc2NyaXB0aW9uOiAiQ3VzdG9tIFZQQyB3aXRoIFByaXZhdGUgR29vZ2xlIEFjY2VzcywgUHJpdmF0ZSBTZXJ2aWNlIENvbm5lY3QsIGFuZCBDbG91ZCBOQVQiCiAgICB9CgogICAgWm9uZSBAQ29tcHV0ZVByb2ZpbGVzQ29sIHsKICAgICAgc3R5bGU6IEBHaG9zdCwgbGF5b3V0OiBjb2x1bW4sIGdhcDogMTQsIGFsaWduOiBzdHJldGNoCgogICAgICBab25lIEBTZXJ2ZXJsZXNzUHJvZmlsZSB7CiAgICAgICAgdGl0bGU6ICJQcm9maWxlIEE6IFNlcnZlcmxlc3MgQ29tcHV0ZSAoZW5hYmxlX2Nsb3VkcnVuKSIKICAgICAgICBzdHlsZTogQFBlYWNoU3ViR3JvdXAsIHdpZHRoOiAzNDQsIGxheW91dDogcm93LCBnYXA6IDEwLCBhbGlnbjogY2VudGVyLCBqdXN0aWZ5OiBjZW50ZXIKICAgICAgICBbY2xvdWRfcnVuX3YyOiAiQ2xvdWQgUnVuIHYyIiB8ICJEaXJlY3QgVlBDIEVncmVzcyJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE1NCwgaWNvbjogIkdjcENsb3VkUnVuIiB9CiAgICAgICAgW2FydGlmYWN0X3JlZzogIkFydGlmYWN0IFJlZ2lzdHJ5IiB8ICJDb250YWluZXIgSW1hZ2VzIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTU0LCBpY29uOiAiQXJ0aWZhY3RSZWdpc3RyeSIgfQogICAgICB9CgogICAgICBab25lIEBLdWJlcm5ldGVzUHJvZmlsZSB7CiAgICAgICAgdGl0bGU6ICJQcm9maWxlIEI6IEVudGVycHJpc2UgSzhzIChlbmFibGVfZ2tlKSIKICAgICAgICBzdHlsZTogQFBlYWNoU3ViR3JvdXAsIGRhc2hlZDogdHJ1ZSwgd2lkdGg6IDM0NCwgbGF5b3V0OiByb3csIGdhcDogMTAsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICAgIFtna2VfYXV0b3BpbG90OiAiR0tFIEF1dG9waWxvdCIgfCAiUHJpdmF0ZSBOb2RlcyArIFdJIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTU0LCBpY29uOiAiR0tFIiB9CiAgICAgICAgW3dvcmtsb2FkX2lkOiAiV29ya2xvYWQgSWRlbnRpdHkiIHwgIktleWxlc3MgT0lEQyBJQU0iXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNTQsIGljb246ICJHY3BMb2NrIiB9CiAgICAgIH0KICAgIH0KICB9CgogIFpvbmUgQFpvbmUyX0dvdmVybmFuY2UgewogICAgYXJlYTogInoyIgogICAgdGl0bGU6ICIzLiBTZWN1cml0eSwgRmluT3BzLCBPYnNlcnZhYmlsaXR5ICYgQWdlbnRpYyBHYXRla2VlcGVyIgogICAgc3R5bGU6IEBHb3Zlcm5hbmNlWm9uZQogICAgbGF5b3V0OiByb3csIGdhcDogMjQsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgoKICAgIFpvbmUgQFNyZUFuZEZpbm9wc0NvbCB7CiAgICAgIHN0eWxlOiBAR2hvc3QsIGxheW91dDogY29sdW1uLCBnYXA6IDEyLCBhbGlnbjogY2VudGVyCiAgICAgIFtjbG91ZF9tb25pdG9yaW5nOiAiQ2xvdWQgTW9uaXRvcmluZyIgfCAiU0xPcyAmIExhdGVuY3kgQWxlcnRzIl0geyBzdHlsZTogQFByb2R1Y3RDYXJkLCB3aWR0aDogMTgyLCBpY29uOiAiQ2xvdWRNb25pdG9yaW5nIiB9CiAgICAgIFtjbG91ZF9sb2dnaW5nOiAiQ2xvdWQgTG9nZ2luZyIgfCAiQXVkaXQgU2luayB0byBCaWdRdWVyeSJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE4MiwgaWNvbjogIkNsb3VkTG9nZ2luZyIgfQogICAgICBbZmlub3BzX2J1ZGdldDogIkNsb3VkIEJpbGxpbmcgRmluT3BzIiB8ICJBbGVydHMgNTAlIC8gOTAlIC8gMTAwJSJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE4MiwgaWNvbjogIkNsb3VkQmlsbGluZyIgfQogICAgfQoKICAgIFpvbmUgQFNvdmVyZWlnbkd1YXJkcmFpbHMgewogICAgICB0aXRsZTogIlNvdmVyZWlnbiBDb250cm9scyAmIE0xTDEgR2F0ZWtlZXBlciIKICAgICAgc3R5bGU6IEBHcmVlblN1Ykdyb3VwLCBsYXlvdXQ6IGNvbHVtbiwgZ2FwOiA4LCBhbGlnbjogY2VudGVyCiAgICAgIFtndWFyZF9pYW06ICJSZXNvdXJjZS1TY29wZWQgSUFNIE9ubHkiXSB7IHN0eWxlOiBAUG9saWN5UGlsbCwgaWNvbjogIlNoaWVsZENoZWNrIiB9CiAgICAgIFtndWFyZF9jbWVrOiAiQ2xvdWQgS01TIENNRUsgKDkwZCBSb3RhdGlvbikiXSB7IHN0eWxlOiBAUG9saWN5UGlsbCwgaWNvbjogIktNUyIgfQogICAgICBbZ3VhcmRfd29ybTogIldPUk0gQmFja3VwIExvY2sgKGVuZm9yY2U9dHJ1ZSkiXSB7IHN0eWxlOiBAUG9saWN5UGlsbCwgaWNvbjogIkxvY2siIH0KICAgICAgW2d1YXJkX20xbDE6ICJNMUwxIHZlcmlmeS5zaCAmIFN1YmFnZW50cyJdIHsgc3R5bGU6IEBQb2xpY3lQaWxsLCBpY29uOiAiQm90IiB9CiAgICB9CiAgfQoKICBab25lIEBab25lNF9EYXRhQUkgewogICAgYXJlYTogIno0IgogICAgdGl0bGU6ICI0LiBEYXRhIExha2Vob3VzZSwgVmVydGV4IEFJICYgSW1tdXRhYmxlIFJlc2lsaWVuY2UgKG1vZHVsZXMvZGF0YS1haS1mb3VuZGF0aW9uICYgYmFja3VwLWRyKSIKICAgIHN0eWxlOiBAUmVzb3VyY2Vab25lCiAgICBsYXlvdXQ6IG1hdHJpeCwgY29sczogMywgc2l6ZXM6IFsiMS4wNWZyIiwgIjEuMTVmciIsICIwLjk1ZnIiXSwgZ2FwOiAxOCwgYWxpZ246IGNlbnRlcgoKICAgIFpvbmUgQFN0b3JhZ2VBbmRMYWtlaG91c2UgewogICAgICB0aXRsZTogIkVuY3J5cHRlZCBEYXRhICYgQ29ycHVzIFN0b3JhZ2UiCiAgICAgIHN0eWxlOiBAQW1iZXJTdWJHcm91cCwgbGF5b3V0OiByb3csIGdhcDogMTIsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICBbZ2NzX3JhZ19idWNrZXQ6ICJDbG91ZCBTdG9yYWdlIiB8ICJVQkxBICsgVmVyc2lvbmluZyJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE2OCwgaWNvbjogIkdjcFN0b3JhZ2VCdWNrZXQiIH0KICAgICAgW2JpZ3F1ZXJ5X2xha2U6ICJCaWdRdWVyeSBMYWtlaG91c2UiIHwgIlBhcnRpdGlvbmVkIEFuYWx5dGljcyJdIHsgc3R5bGU6IEBQcm9kdWN0Q2FyZCwgd2lkdGg6IDE3NCwgaWNvbjogIkJpZ1F1ZXJ5IiB9CiAgICB9CgogICAgWm9uZSBAVmVydGV4QWlQbGF0Zm9ybSB7CiAgICAgIHRpdGxlOiAiTWFuYWdlZCBHZW5BSSAmIEVtYmVkZGluZ3MgKGV1cm9wZS13ZXN0MSkiCiAgICAgIHN0eWxlOiBAQW1iZXJTdWJHcm91cCwgbGF5b3V0OiByb3csIGdhcDogMTIsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICBbdmVydGV4X2dlbWluaTogIlZlcnRleCBBSSBHZW1pbmkiIHwgIkdlbWluaSAzLjUgRmxhc2ggLyBQcm8iXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNzYsIGljb246ICJWZXJ0ZXhBSSIgfQogICAgICBbdmVydGV4X2VtYmVkOiAiVmVydGV4IEVtYmVkZGluZ3MiIHwgInRleHQtZW1iZWRkaW5nLTAwNCAoNzY4ZCkiXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxODQsIGljb246ICJBSVBsYXRmb3JtIiB9CiAgICB9CgogICAgWm9uZSBAUmVzaWxpZW5jZUFuZEttcyB7CiAgICAgIHRpdGxlOiAiQ3J5cHRvICYgRGlzYXN0ZXIgUmVjb3ZlcnkiCiAgICAgIHN0eWxlOiBAQW1iZXJTdWJHcm91cCwgbGF5b3V0OiByb3csIGdhcDogMTIsIGFsaWduOiBjZW50ZXIsIGp1c3RpZnk6IGNlbnRlcgogICAgICBbY2xvdWRfa21zOiAiQ2xvdWQgS01TIENNRUsiIHwgIjkwLURheSBLZXkgUm90YXRpb24iXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNjgsIGljb246ICJLTVMiIH0KICAgICAgW2JhY2t1cF9kcl93b3JtOiAiQmFja3VwICYgRFIgVmF1bHQiIHwgIkltbXV0YWJsZSBXT1JNIExvY2siXSB7IHN0eWxlOiBAUHJvZHVjdENhcmQsIHdpZHRoOiAxNzQsIGljb246ICJTZWN1cml0eUNvbW1hbmRDZW50ZXIiIH0KICAgIH0KICB9Cn0KCltlbnRlcnByaXNlX3VzZXJzXSAtLT4gW2Nsb3VkX2FybW9yX3dhZl0geyBjb2xvcjogJEdjcEJsdWUsIHN0cm9rZVdpZHRoOiAyLCBzb3VyY2VBbmNob3I6ICJyaWdodCIsIHRhcmdldEFuY2hvcjogImxlZnQiLCBjdXJ2ZTogInN0ZXAiLCBzZXF1ZW5jZUJhZGdlOiAiMSIsIGJhZGdlRmlsbDogJEdjcEJsdWUsIGJhZGdlRm9udENvbG9yOiAkU3VyZmFjZVdoaXRlIH0KW2Nsb3VkX2FybW9yX3dhZl0gLS0+IFtnbG9iYWxfbGJdIHsgY29sb3I6ICRHY3BCbHVlLCBzdHJva2VXaWR0aDogMiwgc291cmNlQW5jaG9yOiAicmlnaHQiLCB0YXJnZXRBbmNob3I6ICJsZWZ0IiwgY3VydmU6ICJzdGVwIiB9CltnbG9iYWxfbGJdIC0tPiBbaWFwX3Byb3h5XSB7IGNvbG9yOiAkR2NwQmx1ZSwgc3Ryb2tlV2lkdGg6IDIsIHNvdXJjZUFuY2hvcjogInJpZ2h0IiwgdGFyZ2V0QW5jaG9yOiAibGVmdCIsIGN1cnZlOiAic3RlcCIgfQpbWm9uZTFfUGVyaW1ldGVyXSAtLT4gW3ZwY19yb3V0ZXJfbmF0XSB7IGNvbG9yOiAkR2NwQmx1ZSwgc3Ryb2tlV2lkdGg6IDIsIHNvdXJjZUFuY2hvcjogImJvdHRvbSIsIHRhcmdldEFuY2hvcjogInRvcCIsIGN1cnZlOiAic3RlcCIsIGxhYmVsOiAiWmVyby1UcnVzdCIsIHNlcXVlbmNlQmFkZ2U6ICIyIiwgYmFkZ2VGaWxsOiAkR2NwQmx1ZSwgYmFkZ2VGb250Q29sb3I6ICRTdXJmYWNlV2hpdGUgfQpbdnBjX3JvdXRlcl9uYXRdIC0tPiBbU2VydmVybGVzc1Byb2ZpbGVdIHsgY29sb3I6ICRHY3BCbHVlLCBzdHJva2VXaWR0aDogMiwgc291cmNlQW5jaG9yOiAicmlnaHQiLCB0YXJnZXRBbmNob3I6ICJsZWZ0IiwgY3VydmU6ICJzdGVwIiB9Clt2cGNfcm91dGVyX25hdF0gLS0+IFtLdWJlcm5ldGVzUHJvZmlsZV0geyBjb2xvcjogJEdjcEJsdWUsIHN0cm9rZVdpZHRoOiAyLCBzb3VyY2VBbmNob3I6ICJyaWdodCIsIHRhcmdldEFuY2hvcjogImxlZnQiLCBjdXJ2ZTogInN0ZXAiIH0KW0NvbXB1dGVQcm9maWxlc0NvbF0gLS0+IFtTcmVBbmRGaW5vcHNDb2xdIHsgY29sb3I6ICRCdXNTdHJva2UsIHN0cm9rZVdpZHRoOiAxLjgsIGRhc2hlZDogdHJ1ZSwgc291cmNlQW5jaG9yOiAicmlnaHQiLCB0YXJnZXRBbmNob3I6ICJsZWZ0IiwgY3VydmU6ICJzdGVwIiwgbGFiZWw6ICJUZWxlbWV0cnkiIH0KW1NyZUFuZEZpbm9wc0NvbF0gLS0+IFtTb3ZlcmVpZ25HdWFyZHJhaWxzXSB7IGNvbG9yOiAkR2NwR3JlZW4sIHN0cm9rZVdpZHRoOiAxLjgsIHNvdXJjZUFuY2hvcjogInJpZ2h0IiwgdGFyZ2V0QW5jaG9yOiAibGVmdCIsIGN1cnZlOiAic3RlcCIgfQpbWm9uZTNfQ29tcHV0ZV0gLS0+IFtTdG9yYWdlQW5kTGFrZWhvdXNlXSB7IGNvbG9yOiAkRW1lcmFsZFRlYWwsIHN0cm9rZVdpZHRoOiAyLCBzb3VyY2VBbmNob3I6ICJib3R0b20iLCB0YXJnZXRBbmNob3I6ICJ0b3AiLCBjdXJ2ZTogInN0ZXAiLCBsYWJlbDogIlN0b3JhZ2UgQVBJIiwgc2VxdWVuY2VCYWRnZTogIjMiLCBiYWRnZUZpbGw6ICRFbWVyYWxkVGVhbCwgYmFkZ2VGb250Q29sb3I6ICRTdXJmYWNlV2hpdGUgfQpbWm9uZTNfQ29tcHV0ZV0gLS0+IFtWZXJ0ZXhBaVBsYXRmb3JtXSB7IGNvbG9yOiAkR2NwQmx1ZSwgc3Ryb2tlV2lkdGg6IDIsIHNvdXJjZUFuY2hvcjogImJvdHRvbSIsIHRhcmdldEFuY2hvcjogInRvcCIsIGN1cnZlOiAic3RlcCIsIGxhYmVsOiAiVmVydGV4IEFEQyIsIHNlcXVlbmNlQmFkZ2U6ICI0IiwgYmFkZ2VGaWxsOiAkR2NwQmx1ZSwgYmFkZ2VGb250Q29sb3I6ICRTdXJmYWNlV2hpdGUgfQpbWm9uZTJfR292ZXJuYW5jZV0gLS0+IFtSZXNpbGllbmNlQW5kS21zXSB7IGNvbG9yOiAkR2NwR3JlZW4sIHN0cm9rZVdpZHRoOiAxLjgsIGRhc2hlZDogdHJ1ZSwgc291cmNlQW5jaG9yOiAiYm90dG9tIiwgdGFyZ2V0QW5jaG9yOiAidG9wIiwgY3VydmU6ICJzdGVwIiwgbGFiZWw6ICJDTUVLICYgV09STSIgfQo=) · [`docs/diagrams/foundation_blueprint_v3.dendrite`](docs/diagrams/foundation_blueprint_v3.dendrite) · [`docs/diagrams/foundation_blueprint_v3.drawio`](docs/diagrams/foundation_blueprint_v3.drawio) · [`docs/architecture-gcpdraw.md`](docs/architecture-gcpdraw.md)
>
> 🔗 **Écosystème EMEA SPARK & Applications Compagnons :**
> Ce référentiel fournit le **socle d'infrastructure d'entreprise (Landing Zone IaC)**. Pour explorer les applications déployées sur ce socle :
> - **[RAG Comparison Demo (cloud-gtm/app-rag-comparison)](https://github.com/cloud-gtm/app-rag-comparison)** : Comparateur Recherche Lexicale vs RAG Hybride (Embeddings + BM25 RRF), **Swarm 4 Sous-Agents CRAG (`🤖 Agentic RAG`)**, streaming SSE et évaluation GenAI par Autorater Vertex AI.
> - **[CivicLens (cloud-gtm/civiclens)](https://github.com/cloud-gtm/civiclens)** : Plateforme analytique de finances publiques M57 (GKE Autopilot, Cloud SQL `pgvector`, **Swarm Multi-Agents Google ADK 2.0** et Gemini multimodal).

# GCP AI Foundation Blueprint

[![Terraform Version](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
[![Google Cloud Provider](https://img.shields.io/badge/Google_Cloud_Provider-5.0+-4285F4?style=flat&logo=google-cloud)](https://registry.terraform.io/providers/hashicorp/google/latest)
[![Security Standard](https://img.shields.io/badge/Security-Argolis_%7C_Zero_Trust-green)](docs/ARCHITECTURE.md)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

Socle d'infrastructure Terraform modulaire pour le déploiement d'applications d'Intelligence Artificielle et de charges de travail GenAI sur Google Cloud Platform.

Le blueprint fournit une architecture de référence conforme aux recommandations du **Google Cloud Well-Architected Framework** et aux contraintes de gouvernance **Google Cloud Argolis** (aucune adresse IP publique, administration par tunnel IAP, chiffrement Google-managed et principe du moindre privilège).

---

## Architecture Globale

Consultez le schéma interactif officiel au format GCP Draw dans [docs/architecture-gcpdraw.md](docs/architecture-gcpdraw.md).

```mermaid
flowchart TD
    subgraph Internet_Edge ["1. Edge & Sécurité Périmétrique"]
        User(["Client / Démonstrateur"]) --> LB["External HTTPS Load Balancer\n(IP Statique Globale + SSL Managé)"]
        LB --> WAF["Cloud Armor WAF Policy\n- OWASP Top 10 CRS\n- Rate Limiting (120 req/min)\n- Adaptive ML Defense"]
        LB --> IAP["Identity-Aware Proxy (IAP)\nZero Trust OAuth2"]
    end

    subgraph VPC ["2. VPC Privé (Argolis-Ready, Zéro IP Publique)"]
        IAP -->|Ingress Sécurisé| GKE["Cluster GKE Autopilot Privé\n- Nœuds 100% privés\n- Workload Identity (GSA <-> KSA)"]
        IAP -->|Ingress Sécurisé| CR["Cloud Run v2 (Serverless)\n+ Direct VPC Egress"]
        
        Admin(["Admin / SRE"]) -->|IAP Tunnel 35.235.240.0/20| Bastion["VM Bastion Privée\n(OS Login, Debian 12, kubectl)"]
        Bastion -.->|Administration privée| GKE

        GKE --> NAT["Cloud Router + Cloud NAT"]
        CR --> NAT
        NAT -->|Egress Sécurisé| EgressNet(["APIs Externes / GitHub / HuggingFace"])
    end

    subgraph Data_AI ["3. Data & AI Managed Foundation"]
        GKE & CR -->|Private Google Access / Workload Identity| VertexAI["Vertex AI / Gemini API\n(Gemini 3.5/3.8, text-embedding-002)"]
        GKE & CR -->|Private Service Access / Peering| BQ["BigQuery AI Lakehouse\n- Datasets analytiques\n- Vector Indexing & Embeddings"]
        GKE & CR --> GCS["Cloud Storage\n- gs://...-rag-docs (UBLA, Versioning)\n- gs://...-artifacts (Modèles, Cache)"]
    end

    subgraph SRE_Observability ["4. Observabilité & Résilience SRE"]
        GKE & CR & WAF --> Sink["Cloud Logging Sink\n(Filtre strict anti table_invalid_schema)"]
        Sink --> BQLogs["BigQuery Logs Dataset\n(Tables partitionnées, rétention 90j)"]
        GKE & CR & LB --> Dash["Cloud Monitoring Cockpit\n(Latences P95, CPU/RAM, Requêtes WAF)"]
    end
```

---

## Catalogue des Modules

Le blueprint est décomposé en 9 modules Terraform autonomes et composables :

| Module | Répertoire | Description & Ressources Clés |
| :--- | :--- | :--- |
| **Networking** | `modules/networking` | VPC custom, sous-réseau primaire (`10.10.0.0/20`), plages secondaires Pods (`10.20.0.0/16`) et Services (`10.30.0.0/20`), Cloud Router, Cloud NAT et Private Service Access (PSA). |
| **Security & WAF** | `modules/security-waf` | Stratégie Cloud Armor WAF avec règles CRS OWASP Top 10 (SQLi, XSS, RCE), rate limiting, protection adaptative L7, IP externe statique et certificat SSL. |
| **Compute GKE** | `modules/compute-gke` | Cluster GKE Autopilot 100 % privé, configuration Workload Identity, plan de sauvegarde Backup for GKE et permissions IAM ciblées (`roles/aiplatform.user`, `roles/storage.objectUser`). |
| **Compute Cloud Run** | `modules/compute-cloudrun` | Service Cloud Run v2 serverless avec Direct VPC Egress, auto-scaling de 0 à 5 instances, `no-cpu-throttling`, timeout de 300s et Service Account dédié. |
| **Data & AI Foundation** | `modules/data-ai-foundation` | Activation des APIs Vertex AI et BigQuery, dataset BigQuery Lakehouse, bucket GCS RAG documents (`versioning`, `UBLA`) et bucket d'artefacts. |
| **Bastion Host** | `modules/bastion` | Instance Compute Engine Debian 12 sans IP publique, connectable exclusivement par tunnel IAP, avec `kubectl`, `gke-gcloud-auth-plugin`, `tinyproxy` et `OS Login`. |
| **Observabilité SRE** | `modules/observability` | Sink Cloud Logging avec filtre d'exclusion des namespaces système (prévention de l'erreur `table_invalid_schema`), dataset BigQuery partitionné et Dashboard Cloud Monitoring. |
| **FinOps Budget** | `modules/finops-budget` | Alerte budgétaire Cloud Billing avec seuils à 50 %, 75 %, 90 %, 100 % réel et 100 % prévisionnel, canal de notification par email. |
| **Backup & DR** | `modules/backup-dr` | Coffres-forts immuables WORM pour la rétention opérationnelle et géo-redondante, intégration Backup for GKE pour l'état applicatif et les volumes persistants. |

---

## Profils d'Architecture Clés en Main (Réutilisabilité)

Pour faciliter la réutilisation selon le contexte (démonstration rapide vs production souveraine), le fichier [`terraform.tfvars.example`](file:///usr/local/google/home/hoffmannw/gcp-ai-foundation-blueprint/terraform.tfvars.example) propose deux profils préconfigurés :

| Profil | Cas d'usage cible | Configuration Compute & Sécurité | Temps & Coût |
| :--- | :--- | :--- | :--- |
| **Profil A : Démo Légère & Serverless** | Démos rapides (`app-rag-comparison`), PoCs agiles, environnements éphémères. | `enable_cloudrun = true`, `enable_gke = false`, `enable_bastion = false`, `enable_waf = false`, `force_destroy = true`. | **~2 min** / Coût quasi nul au repos (*scale-to-zero*). |
| **Profil B : Production Enterprise Souveraine** | Déploiements d'entreprise (`app-civiclens`), données sensibles, conformité SecOps/DORA. | `enable_gke = true`, `enable_waf = true`, `enable_bastion = true`, `enable_backup_dr = true`, `deletion_protection = true`. | **~15 min** / Haute disponibilité multi-zones & WORM. |

---

## Variables Principales (`variables.tf`)

Le module racine expose 27 variables typées et validées (`validation {}`) :

| Variable | Type | Valeur par défaut | Description |
| :--- | :--- | :--- | :--- |
| `project_id` | `string` | *Requis* | Identifiant du projet Google Cloud cible (validé par regex). |
| `region` | `string` | `"europe-west1"` | Région GCP principale pour le réseau, le compute et les données. |
| `zone` | `string` | `"europe-west1-b"` | Zone GCP principale pour la VM Bastion. |
| `resource_prefix` | `string` | `"ai-base"` | Préfixe de nommage appliqué à toutes les ressources créées. |
| `enable_random_suffix` | `bool` | `true` | Ajoute un suffixe aléatoire anti-collision aux ressources et buckets GCS. |
| `random_suffix_length` | `number` | `4` | Longueur du suffixe aléatoire (entre 2 et 8 caractères). |
| `enable_gke` | `bool` | `true` | Provisionne le cluster privé GKE Autopilot. |
| `enable_cloudrun` | `bool` | `false` | Provisionne le service serverless Cloud Run v2 avec Direct VPC Egress. |
| `enable_bastion` | `bool` | `true` | Provisionne la VM Bastion privée accessible uniquement via tunnel IAP. |
| `enable_waf` | `bool` | `true` | Provisionne la politique Cloud Armor WAF (OWASP Top 10 + Rate Limiting). |
| `excluded_upload_paths` | `list(string)` | `["/api/documents/upload"]` | Chemins URL exclus de l'inspection OWASP sur le corps de requête (évite les faux positifs 403 lors de l'upload de fichiers PDF). |
| `domain_name` | `string` | `""` | Nom de domaine pour le certificat SSL managé (laisser vide pour ignorer). |
| `admin_email` | `string` | `""` | Email de l'administrateur autorisé sur IAP (`roles/iap.httpsResourceAccessor`). |
| `enable_observability` | `bool` | `true` | Crée le sink Cloud Logging vers BigQuery et le cockpit Cloud Monitoring. |
| `alert_email` | `string` | `""` | Adresse email destinataire des alertes SRE Cloud Monitoring et FinOps. |
| `billing_account` | `string` | `""` | ID du compte de facturation Cloud Billing (active le module budget). |
| `budget_amount` | `number` | `100` | Montant mensuel cible du budget FinOps (doit être > 0). |
| `budget_currency` | `string` | `"USD"` | Devise du budget FinOps (`USD`, `EUR`, etc.). |
| `enable_backup_dr` | `bool` | `false` | Active le module Backup & DR (coffres WORM et sauvegarde GKE). |
| `dr_region` | `string` | `"europe-west4"` | Région secondaire pour le coffre de sauvegarde géo-redondant. |
| `backup_daily_retention_days` | `number` | `7` | Durée de rétention des sauvegardes quotidiennes (en jours). |
| `backup_weekly_retention_weeks` | `number` | `4` | Durée de rétention des sauvegardes hebdomadaires DR (en semaines). |
| `enable_geo_dr_vault` | `bool` | `true` | Provisionne le coffre-fort secondaire dans `dr_region`. |
| `deletion_protection` | `bool` | `false` | Protection contre la suppression accidentelle (GKE, Cloud Run). Mettre à `true` en production. |
| `force_destroy` | `bool` | `false` | Autorise la suppression des buckets GCS et datasets BigQuery non vides lors d'un `terraform destroy` (utile en démo). |
| `kms_key_name` | `string` | `""` | Identifiant de clé Cloud KMS (CMEK) optionnelle pour chiffrer BigQuery et GCS. |
| `labels` | `map(string)` | `{...}` | Labels FinOps appliqués uniformément à toutes les ressources via `default_labels`. |

---

## Outputs Plug-and-Play (`outputs.tf`)

Les sorties sont conçues pour être injectées directement dans les scripts de déploiement des applications clientes (`terraform output -raw <nom>`) sans nécessiter de parsing manuel :

| Output | Description & Utilisation Aval |
| :--- | :--- |
| `vpc_network_name` / `subnet_name` | Noms courts du VPC et du sous-réseau (pour `--network` et `--subnet` avec Cloud Run Direct VPC Egress). |
| `external_ip` / `external_ip_name` | Adresse IPv4 externe et son nom court (pour l'annotation Kubernetes `ingress.global-static-ip-name`). |
| `waf_policy_id` / `waf_policy_name` | URI complet et nom court de la stratégie Cloud Armor WAF (pour l'objet `BackendConfig` GKE). |
| `ssl_certificate_name` | Nom du certificat SSL managé (pour l'annotation Kubernetes `ingress.gcp.kubernetes.io/pre-shared-cert`). |
| `lakehouse_dataset_id` | Identifiant du dataset BigQuery Lakehouse (`{prefix}_lakehouse`). |
| `rag_bucket_name` / `rag_bucket_url` | Nom et URL `gs://` du bucket Cloud Storage dédié aux documents RAG. |
| `artifacts_bucket_name` / `artifacts_bucket_url` | Nom et URL `gs://` du bucket Cloud Storage dédié aux artefacts et caches d'évaluation IA. |
| `gke_cluster_name` / `gke_cluster_endpoint` | Nom et endpoint privé du cluster GKE Autopilot. |
| `gke_get_credentials_command` | Commande `gcloud container clusters get-credentials ... --internal-ip` prête à exécuter. |
| `gke_app_service_account_email` | Email du Google Service Account pour GKE Workload Identity. |
| `workload_identity_pool` | Pool Workload Identity du projet (`{project_id}.svc.id.goog`). |
| `cloudrun_service_name` / `cloudrun_service_uri` | Nom et URL HTTPS du service Cloud Run v2. |
| `cloudrun_service_account_email` | Email du Service Account dédié au service Cloud Run. |
| `bastion_ssh_command` | Commande `gcloud compute ssh ... --tunnel-through-iap` pour se connecter au bastion privé. |
| `bastion_name` / `bastion_zone` | Nom court de la VM Bastion et zone de déploiement (pour scripts d'automatisation IAP). |
| `project_id` / `region` | Identifiant du projet Google Cloud et région primaire de déploiement. |
| `agentic_platform_config` | Objet JSON structuré (endpoints Vertex AI, dataset BigQuery Lakehouse, buckets GCS et Workload Identity) consommé par les Swarms **Google ADK 2.0** (`civiclens`) et **CRAG** (`app-rag-comparison`). |


---

## Démarrage Rapide

### 1. Prérequis
- `gcloud` CLI authentifié (`gcloud auth login` et `gcloud auth application-default login`).
- `terraform` version 1.5.0 ou supérieure.
- Rôle `roles/owner` ou `roles/editor` sur le projet GCP cible.

### 2. Initialisation du Projet
Exécutez le script d'initialisation pour activer les APIs requises et créer le bucket d'état distant :

```bash
./scripts/bootstrap.sh <VOTRE_PROJECT_ID> europe-west1
```

### 3. Configuration & Déploiement

```bash
# 1. Copier le fichier d'exemple des variables
cp terraform.tfvars.example terraform.tfvars

# 2. Renseigner au minimum project_id et admin_email dans terraform.tfvars

# 3. Initialiser les providers et modules
terraform init

# 4. Valider le plan d'exécution
terraform plan

# 5. Appliquer l'infrastructure
terraform apply
```

### 4. Déploiement d'une Application sur ce Socle
Une fois l'infrastructure provisionnée, déployez l'une des applications compatibles :
- Pour déployer le chatbot de comparaison RAG :
  ```bash
  cd ../app-rag-comparison
  ./scripts/deploy-to-blueprint.sh --blueprint-dir=../gcp-ai-foundation-blueprint
  ```
- Consultez le [Guide d'Intégration Applicative](docs/APPLICATION_INTEGRATION.md) pour les architectures personnalisées.

---

## Sécurité & Conformité Argolis

- **Zéro IP publique Compute** : Aucun nœud Kubernetes, VM Bastion ou conteneur ne possède d'adresse IP externe (`constraints/compute.vmExternalIpAccess`).
- **Trafic Egress maîtrisé** : Toutes les connexions sortantes (téléchargement de dépendances, modèles HuggingFace) transitent par Cloud NAT.
- **Accès d'administration IAP** : L'accès SSH au bastion utilise le tunnel Identity-Aware Proxy sur la plage réseau `35.235.240.0/20`.
- **Authentification par token temporaire** : Si vous travaillez depuis un environnement Cloudtop avec un compte `@google.com` soumis à restriction de domaine, exportez un jeton valide avant d'appliquer Terraform :
  ```bash
  export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token --account=user@votre-domaine.altostrat.com)
  terraform apply
  ```

---

## 🤖 Architecture Agentique & Skills Embarqués (`M1L1 Skills Framework`)

Ce dépôt intègre l'architecture **AI-Native Software Engineering (Elevate 2026 & EMEA SPARK)** ainsi que les 5 *Skill Patterns* du framework officiel **`M1L1 Skills Framework`** (*Tool Wrapper*, *Auth Recipe*, *Generator / Experience Before Theory*, *Reviewer Checklist* et *Workflow*).

### 🔄 Cycle de Vie IaC Assisté par Agents : Où et Quand chaque Agent entre en action

Contrairement à une application web classique, un socle Terraform (Landing Zone) mobilise ses agents tout au long du **cycle d'ingénierie d'infrastructure (Day-0 ➔ Day-1 ➔ Day-2)** avant d'alimenter en **sortie (`agentic_platform_config`)** les Swarms applicatifs en production :

```mermaid
flowchart LR
    subgraph Day0 ["1. Day-0 : Cadrage & FinOps"]
        Dev(["Ingénieur Cloud / CE"]) -->|Choix du profil tfvars| FinOps["🤖 finops-advisor\n(.agents/agents/finops-advisor.md)\n• Arbitrage Profil A (0€ repos)\n  vs Profil B (GKE + WORM)\n• Seuils Cloud Billing 50/90/100%"]
    end

    subgraph Day1 ["2. Day-1 : Codage & Audit des Modules .tf"]
        FinOps --> TFCode["Modification des modules\nnetworking / security-waf /\ncompute-gke / backup-dr"]
        TFCode -->|Audit Sécurité| SecOps["🛡️ secops-auditor\n(.agents/agents/secops-auditor.md)\n• SaferGCP : Zéro IP publique\n• IAM scopé à la ressource\n• Cloud Armor exclusion upload PDF"]
        TFCode -->|Audit Résilience| DR["🌪️ dr-chaos-architect\n(.agents/agents/dr-chaos-architect.md)\n• Coffres WORM (google-beta)\n• Sync addon Backup for GKE\n• deletion_protection"]
    end

    subgraph Gatekeeper ["3. Pre-Commit : Skill M1L1"]
        SecOps & DR --> Skill["🛠️ terraform-blueprint-validation\n(scripts/verify.sh)\n• terraform fmt -check\n• terraform validate\n• Contrôle outputs & toggles"]
    end

    subgraph Day2 ["4. Day-2 : Handshake Runtime Multi-Agents"]
        Skill -->|terraform apply| Output["⚡ Output : agentic_platform_config\n(Endpoints Vertex AI, Lakehouse BQ,\nBuckets GCS, Workload Identity)"]
        Output -->|Alimente| AppRAG["🤖 Swarm 4 Agents CRAG\n(app-rag-comparison)"]
        Output -->|Alimente| AppCivic["🏛️ Swarm 4 Agents ADK 2.0\n(civiclens)"]
    end
```

### 📊 Matrice de Déclenchement des Agents & Skills

| Agent / Skill | Couche | Où s'exécute-t-il ? | Quand entre-t-il en action ? (Déclencheur) | Ce qu'il vérifie / produit concrètement |
| :--- | :--- | :--- | :--- | :--- |
| **[`finops-advisor`](.agents/agents/finops-advisor.md)** | **Couche 1** *(Build-Time)* | IDE / CLI *(Jetski, Antigravity, Gemini CLI)* | Lors de la création ou modification de `terraform.tfvars` ou `modules/finops-budget/`. | Compare le coût mensuel du **Profil A** (Cloud Run *scale-to-zero* + Direct VPC Egress sans VM NAT fixe) vs **Profil B** (GKE Autopilot + WORM), vérifie les règles de cycle de vie GCS (`Nearline`/`Archive`) et les alertes budgétaires. |
| **[`secops-auditor`](.agents/agents/secops-auditor.md)** | **Couche 1** *(Build-Time)* | IDE / CLI *(Jetski, Antigravity, Gemini CLI)* | Avant tout commit sur `modules/security-waf/`, `modules/networking/`, ou les rôles IAM. | Contrôle l'absence de `google_project_iam_member` trop permissif, vérifie `enable_private_nodes = true`, et garantit que Cloud Armor exclut `/api/documents/upload` de l'inspection OWASP L7 (évitant les faux positifs HTTP 403 sur les PDF). |
| **[`dr-chaos-architect`](.agents/agents/dr-chaos-architect.md)** | **Couche 1** *(Build-Time)* | IDE / CLI *(Jetski, Antigravity, Gemini CLI)* | Lors de l'activation de `enable_backup_dr = true` ou de l'édition de `modules/compute-gke/`. | Vérifie l'utilisation du provider `google-beta` pour les `google_backup_dr_backup_vault`, la cohérence entre le plan de sauvegarde et l'addon `gke_backup_agent_config`, et le verrouillage `deletion_protection`. |
| **[`terraform-blueprint-validation`](.agents/skills/terraform-blueprint-validation/SKILL.md)** | **Couche 1** *(Gatekeeper)* | Terminal local ou CI/CD (`scripts/verify.sh`) | Systématiquement avant chaque `git commit` ou ouverture de Pull Request. | Exécute les 4 portes de contrôle : `terraform fmt -check -recursive`, `terraform validate`, présence des variables `enable_*`, et présence de `agentic_platform_config`. |
| **`agentic_platform_config`** | **Couche 2** *(Pont Runtime)* | Sortie Terraform (`outputs.tf`) | Après `terraform apply`, lors du déploiement de `app-rag-comparison` ou `civiclens`. | Injecte automatiquement les identifiants du Lakehouse BigQuery, des buckets GCS RAG et du pool Workload Identity dans les Swarms **CRAG** et **Google ADK 2.0**. |

### 🎬 Playbook de Démo Live : 3 Scénarios Pas-à-Pas (IDE / Gemini CLI / Jetski)

Lors d'une démonstration client ou d'un atelier d'architecture, copiez-collez directement ces 3 commandes ou prompts pour montrer comment les agents protègent le socle Terraform en temps réel :

1. **Scénario 1 — Démontrer l'Audit SecOps & Cloud Armor (`secops-auditor`)** :
   > 💬 *Prompt à copier dans Jetski / Antigravity / Gemini CLI :*
   > `"Invoque le sous-agent secops-auditor pour auditer modules/security-waf/main.tf et vérifier pourquoi les uploads de fichiers PDF sur /api/documents/upload ne sont pas bloqués par la règle OWASP SQLi/XSS de Cloud Armor."`
   - **Résultat démontré** : L'agent inspecte la règle de priorité Cloud Armor, explique l'exclusion ciblée `request.path.matches('/api/documents/upload')` (Pattern *Experience Before Theory*) et valide l'absence d'IP publique.

2. **Scénario 2 — Démontrer l'Arbitrage FinOps Serverless vs Enterprise (`finops-advisor`)** :
   > 💬 *Prompt à copier dans Jetski / Antigravity / Gemini CLI :*
   > `"Invoque le sous-agent finops-advisor pour comparer le coût récurrent au repos entre le Profil A (Serverless Cloud Run avec Direct VPC Egress) et le Profil B (GKE Autopilot + Backup DR WORM) dans terraform.tfvars.example."`
   - **Résultat démontré** : L'agent détaille pourquoi `Direct VPC Egress` économise le coût fixe d'un Serverless VPC Access Connector (`e2-micro` 24/7) et valide les seuils d'alerte Cloud Billing (`50% / 90% / 100%`).

3. **Scénario 3 — Exécuter le Gatekeeper Automatisé M1L1 (`verify.sh`)** :
   ```bash
   ./.agents/skills/terraform-blueprint-validation/scripts/verify.sh
   ```
   - **Résultat démontré** : Exécution en moins de 5 secondes des 4 contrôles déterministes (`terraform fmt`, `terraform validate`, toggles `enable_*` et sortie `agentic_platform_config`).

---

## Licence

Ce projet est distribué sous licence Apache 2.0. Consultez le fichier [LICENSE](LICENSE) pour plus d'informations.



