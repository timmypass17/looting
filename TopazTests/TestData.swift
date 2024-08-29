//
//  TestData.swift
//  TopazTests
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

let dealsJSON: Data = 
"""
{
    "nextOffset": 20,
    "hasMore": true,
    "list": [
        {
            "id": "018d937e-e960-71f6-9fb9-52c6bdfc1a29",
            "slug": "emergency-call-112",
            "title": "Emergency Call 112!",
            "type": null,
            "deal": {
                "shop": {
                    "id": 20,
                    "name": "GameBillet"
                },
                "price": {
                    "amount": 13.04,
                    "amountInt": 1304,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 14.99,
                    "amountInt": 1499,
                    "currency": "USD"
                },
                "cut": 13,
                "voucher": null,
                "storeLow": {
                    "amount": 13.04,
                    "amountInt": 1304,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 9.59,
                    "amountInt": 959,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-02-11T00:35:26+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-5705-708b-84e5-7c73f93a8c86/"
            }
        },
        {
            "id": "018d937e-e9ab-70f4-bd05-1db79cec46d2",
            "slug": "rebel-galaxy-outlaw",
            "title": "Rebel Galaxy Outlaw",
            "type": "game",
            "deal": {
                "shop": {
                    "id": 35,
                    "name": "GOG"
                },
                "price": {
                    "amount": 4.49,
                    "amountInt": 449,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 29.99,
                    "amountInt": 2999,
                    "currency": "USD"
                },
                "cut": 85,
                "voucher": null,
                "storeLow": {
                    "amount": 4.49,
                    "amountInt": 449,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 1.49,
                    "amountInt": 149,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [
                    {
                        "id": 1000,
                        "name": "Drm Free"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-19T15:12:01+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-b6f9-70d4-a097-149b103cafdd/"
            }
        },
        {
            "id": "018d937e-e9ac-7156-83a6-7d2801ed7ad3",
            "slug": "sid-meiers-civilization-v-cradle-of-civilization-americas",
            "title": "Sid Meier's Civilization® V - Cradle of Civilization - Americas",
            "type": null,
            "deal": {
                "shop": {
                    "id": 20,
                    "name": "GameBillet"
                },
                "price": {
                    "amount": 2.51,
                    "amountInt": 251,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 2.99,
                    "amountInt": 299,
                    "currency": "USD"
                },
                "cut": 16,
                "voucher": null,
                "storeLow": {
                    "amount": 2.51,
                    "amountInt": 251,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 0.58,
                    "amountInt": 58,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-02-11T00:35:21+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-c7e6-7184-b44c-4e3608d127fb/"
            }
        },
        {
            "id": "018d937e-e9ad-72bf-8d8b-27d5f8acfdcf",
            "slug": "vrc-pro-off-road-complete",
            "title": "VRC PRO OFF-ROAD COMPLETE",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 69.58,
                    "amountInt": 6958,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 128.92,
                    "amountInt": 12892,
                    "currency": "USD"
                },
                "cut": 46,
                "voucher": null,
                "storeLow": {
                    "amount": 24.85,
                    "amountInt": 2485,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 24.85,
                    "amountInt": 2485,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-05-27T19:23:30+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-f06e-7087-a76c-62d65cfc26a9/"
            }
        },
        {
            "id": "018d937e-e9b2-714b-8c05-5c14eac1f644",
            "slug": "bomber-crew-secret-weapons",
            "title": "Bomber Crew Secret Weapons",
            "type": "dlc",
            "deal": {
                "shop": {
                    "id": 37,
                    "name": "Humble Store"
                },
                "price": {
                    "amount": 2.37,
                    "amountInt": 237,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 6.99,
                    "amountInt": 699,
                    "currency": "USD"
                },
                "cut": 66,
                "voucher": null,
                "storeLow": {
                    "amount": 0.74,
                    "amountInt": 74,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 0.49,
                    "amountInt": 49,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-06-20T19:33:00+02:00",
                "expiry": "2024-07-04T19:00:00+02:00",
                "url": "https://itad.link/018d9386-3437-731f-8f0c-df6ddb620c87/"
            }
        },
        {
            "id": "018d937e-e9b2-714b-8c05-5c14ee53b562",
            "slug": "life-is-feudal-your-own-2-pack",
            "title": "Life is Feudal: Your Own (2-Pack)",
            "type": "game",
            "deal": {
                "shop": {
                    "id": 6,
                    "name": "Fanatical"
                },
                "price": {
                    "amount": 54.59,
                    "amountInt": 5459,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 64.99,
                    "amountInt": 6499,
                    "currency": "USD"
                },
                "cut": 16,
                "voucher": null,
                "storeLow": {
                    "amount": 11.04,
                    "amountInt": 1104,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 11.04,
                    "amountInt": 1104,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-02-13T13:20:33+01:00",
                "expiry": "2024-02-20T17:00:00+01:00",
                "url": "https://itad.link/018d9386-8d0a-7160-be6d-47cd155a9fee/"
            }
        },
        {
            "id": "018d937e-e9b4-730e-bfaf-ed97c0dfca25",
            "slug": "44-hat-pack-bundle",
            "title": "44 Hat Pack Bundle",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 26.88,
                    "amountInt": 2688,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 63.56,
                    "amountInt": 6356,
                    "currency": "USD"
                },
                "cut": 58,
                "voucher": null,
                "storeLow": {
                    "amount": 9.84,
                    "amountInt": 984,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 9.84,
                    "amountInt": 984,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-02-11T04:54:05+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-81dc-71a4-93b3-ba9ff4a6298a/"
            }
        },
        {
            "id": "018d937e-e9b6-713b-83f6-4f060c7b4fb2",
            "slug": "valhalla-hills-fire-mountains",
            "title": "Valhalla Hills: Fire Mountains",
            "type": "dlc",
            "deal": {
                "shop": {
                    "id": 37,
                    "name": "Humble Store"
                },
                "price": {
                    "amount": 0.5,
                    "amountInt": 50,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 0.99,
                    "amountInt": 99,
                    "currency": "USD"
                },
                "cut": 49,
                "voucher": null,
                "storeLow": {
                    "amount": 0.28,
                    "amountInt": 28,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 0.25,
                    "amountInt": 25,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-06-20T19:12:58+02:00",
                "expiry": "2024-07-04T19:00:00+02:00",
                "url": "https://itad.link/018d9386-ed35-7218-8946-56cd5bd79cdc/"
            }
        },
        {
            "id": "018d937e-e9b6-713b-83f6-4f060f31bd0d",
            "slug": "sky-to-fly-2-in-1-steampunk-games-bundle",
            "title": "Sky To Fly: 2 in 1 Steampunk Games Bundle",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 7.18,
                    "amountInt": 718,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 7.98,
                    "amountInt": 798,
                    "currency": "USD"
                },
                "cut": 10,
                "voucher": null,
                "storeLow": {
                    "amount": 3.22,
                    "amountInt": 322,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 3.22,
                    "amountInt": 322,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-03-21T18:23:10+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-ca71-731a-9659-da224fbe6751/"
            }
        },
        {
            "id": "018d937e-e9b9-7017-be46-d6fe0e0a0dbb",
            "slug": "sparkle-3",
            "title": "Sparkle 3",
            "type": null,
            "deal": {
                "shop": {
                    "id": 68,
                    "name": "Gamer Thor"
                },
                "price": {
                    "amount": 3.79,
                    "amountInt": 379,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 4.99,
                    "amountInt": 499,
                    "currency": "USD"
                },
                "cut": 24,
                "voucher": null,
                "storeLow": {
                    "amount": 3.79,
                    "amountInt": 379,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 0.49,
                    "amountInt": 49,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-06-14T12:55:25+02:00",
                "expiry": null,
                "url": "https://itad.link/0190131d-7f4a-7272-bab9-1e87dc67d134/"
            }
        },
        {
            "id": "018d937e-e9b9-7017-be46-d6fe128489cc",
            "slug": "field-of-glory-masters-edition",
            "title": "Field of Glory Masters Edition",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 28,
                    "name": "GamesPlanet FR"
                },
                "price": {
                    "amount": 44.82,
                    "amountInt": 4482,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 49.81,
                    "amountInt": 4981,
                    "currency": "USD"
                },
                "cut": 10,
                "voucher": null,
                "storeLow": {
                    "amount": 17.44,
                    "amountInt": 1744,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 13.69,
                    "amountInt": 1369,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-04-29T10:35:32+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-62be-72f9-90c3-1b5c25413431/"
            }
        },
        {
            "id": "018d937e-e9c3-73d9-bb2c-acd0ffb829e5",
            "slug": "masterpiece-bundle",
            "title": "Masterpiece bundle",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 44.68,
                    "amountInt": 4468,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 89.68,
                    "amountInt": 8968,
                    "currency": "USD"
                },
                "cut": 50,
                "voucher": null,
                "storeLow": {
                    "amount": 1.99,
                    "amountInt": 199,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 1.99,
                    "amountInt": 199,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-17T19:17:18+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-93e9-7334-b7b3-51aea4b4bc6a/"
            }
        },
        {
            "id": "018d937e-e9ca-71cf-bef1-18c9370e1ed4",
            "slug": "assault-suit-leynos-special-edition",
            "title": "Assault Suit Leynos Special Edition",
            "type": null,
            "deal": {
                "shop": {
                    "id": 37,
                    "name": "Humble Store"
                },
                "price": {
                    "amount": 1.44,
                    "amountInt": 144,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 28.99,
                    "amountInt": 2899,
                    "currency": "USD"
                },
                "cut": 95,
                "voucher": null,
                "storeLow": {
                    "amount": 1.44,
                    "amountInt": 144,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 1.44,
                    "amountInt": 144,
                    "currency": "USD"
                },
                "flag": "H",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-20T19:12:07+02:00",
                "expiry": "2024-07-04T19:00:00+02:00",
                "url": "https://itad.link/018d9386-2a79-71d1-ad94-02e0baa2d512/"
            }
        },
        {
            "id": "018d937e-e9ca-71cf-bef1-18c937478c2d",
            "slug": "140-game-and-soundtrack",
            "title": "140 Game + Soundtrack",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 7.98,
                    "amountInt": 798,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 9.98,
                    "amountInt": 998,
                    "currency": "USD"
                },
                "cut": 20,
                "voucher": null,
                "storeLow": {
                    "amount": 1.58,
                    "amountInt": 158,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 1.58,
                    "amountInt": 158,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-03-21T18:20:16+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-7d42-70ba-89a3-d8f94dc70c0f/"
            }
        },
        {
            "id": "018d937e-e9cb-728b-8309-9798ff1da8c3",
            "slug": "battlerush-full-pack",
            "title": "BattleRush - Full Pack",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 23.98,
                    "amountInt": 2398,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 29.98,
                    "amountInt": 2998,
                    "currency": "USD"
                },
                "cut": 20,
                "voucher": null,
                "storeLow": {
                    "amount": 2.38,
                    "amountInt": 238,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 2.38,
                    "amountInt": 238,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-05T19:15:53+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-2ea6-738e-9feb-10e72607ccd4/"
            }
        },
        {
            "id": "018d937e-e9cc-7214-a12e-4a2758cfebde",
            "slug": "educational-card-games",
            "title": "Educational Card Games",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 2.38,
                    "amountInt": 238,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 2.98,
                    "amountInt": 298,
                    "currency": "USD"
                },
                "cut": 20,
                "voucher": null,
                "storeLow": {
                    "amount": 1.15,
                    "amountInt": 115,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 1.15,
                    "amountInt": 115,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-02-11T06:27:33+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-5622-70d2-87b4-6a9e69f4b871/"
            }
        },
        {
            "id": "018d937e-e9d1-715f-8eae-4e22ec8b1a38",
            "slug": "pixel-puzzles-ultimate-jigsaw-starter-kit",
            "title": "Pixel Puzzles Ultimate: Jigsaw Starter Kit",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 2.65,
                    "amountInt": 265,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 28.9,
                    "amountInt": 2890,
                    "currency": "USD"
                },
                "cut": 91,
                "voucher": null,
                "storeLow": {
                    "amount": 1.26,
                    "amountInt": 126,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 1.26,
                    "amountInt": 126,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-17T19:17:12+02:00",
                "expiry": "2024-06-24T19:00:00+02:00",
                "url": "https://itad.link/018d9386-ade3-7272-949b-75b6de96ef49/"
            }
        },
        {
            "id": "018d937e-e9d1-715f-8eae-4e22ef4a978d",
            "slug": "europa-universalis-iv-conquest-of-paradise-content-pack",
            "title": "Europa Universalis IV: Conquest of Paradise Content Pack",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 6.92,
                    "amountInt": 692,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 7.96,
                    "amountInt": 796,
                    "currency": "USD"
                },
                "cut": 13,
                "voucher": null,
                "storeLow": {
                    "amount": 2.32,
                    "amountInt": 232,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 2.32,
                    "amountInt": 232,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-05-23T20:15:35+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-5a8f-72db-a4f4-796c2e4fd075/"
            }
        },
        {
            "id": "018d937e-e9d2-71f2-b0ca-21409c0f37ea",
            "slug": "wheel-tuning-pack-bundle",
            "title": "Wheel Tuning Pack Bundle",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 2.98,
                    "amountInt": 298,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 5.98,
                    "amountInt": 598,
                    "currency": "USD"
                },
                "cut": 50,
                "voucher": null,
                "storeLow": {
                    "amount": 0.88,
                    "amountInt": 88,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 0.88,
                    "amountInt": 88,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    },
                    {
                        "id": 2,
                        "name": "Mac"
                    },
                    {
                        "id": 3,
                        "name": "Linux"
                    }
                ],
                "timestamp": "2024-05-30T19:15:56+02:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-f4e6-7247-88e3-0de101d8a2aa/"
            }
        },
        {
            "id": "018d937e-e9d3-70a4-ad73-e6d318ae39e6",
            "slug": "proze-enlightenment-soundtrack-bundle",
            "title": "PROZE: Enlightenment Soundtrack Bundle",
            "type": "package",
            "deal": {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 7.58,
                    "amountInt": 758,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 7.98,
                    "amountInt": 798,
                    "currency": "USD"
                },
                "cut": 5,
                "voucher": null,
                "storeLow": {
                    "amount": 2.36,
                    "amountInt": 236,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 2.36,
                    "amountInt": 236,
                    "currency": "USD"
                },
                "flag": null,
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-02-11T06:27:22+01:00",
                "expiry": null,
                "url": "https://itad.link/018d9386-b272-70b9-a7c2-a66876db3ee7/"
            }
        }
    ]
}
""".data(using: .utf8)!

let gameSearchJSON =
"""
[
    {
        "id": "018d937f-4adb-73a6-a9e5-94ff5f2b847b",
        "slug": "kingdom-hearts-hd-1-5-and-2-5-remix",
        "title": "KINGDOM HEARTS - HD 1 5+2 5 ReMIX",
        "type": "game",
        "mature": false
    },
    {
        "id": "018d937f-4c74-7165-b84a-3c17130780aa",
        "slug": "kingdom-hearts-iii-and-re-mind",
        "title": "KINGDOM HEARTS III + Re Mind",
        "type": "game",
        "mature": false
    },
    {
        "id": "018d937f-4af9-70b7-80ae-6b01397f31e4",
        "slug": "kingdom-hearts-hd-2-8-final-chapter-prologue",
        "title": "KINGDOM HEARTS HD 2 8 FINAL CHAPTER PROLOGUE",
        "type": "game",
        "mature": false
    },
    {
        "id": "01901254-3b8d-70ee-ad6e-834bdd7b1000",
        "slug": "kingdom-hearts-integrum-masterpiece",
        "title": "KINGDOM HEARTS INTEGRUM MASTERPIECE",
        "type": "package",
        "mature": false
    },
    {
        "id": "018d937f-4c75-71ef-8973-db0f42a91192",
        "slug": "kingdom-hearts-melody-of-memory",
        "title": "KINGDOM HEARTS Melody of Memory",
        "type": "game",
        "mature": false
    }
]
""".data(using: .utf8)!

let gameJSON =
"""
{
    "id": "018d937f-4adb-73a6-a9e5-94ff5f2b847b",
    "slug": "kingdom-hearts-hd-1-5-and-2-5-remix",
    "title": "KINGDOM HEARTS - HD 1 5+2 5 ReMIX",
    "type": "game",
    "mature": false,
    "assets": {
        "boxart": "https://dbxce1spal1df.cloudfront.net/018d937f-4adb-73a6-a9e5-94ff5f2b847b/boxart.jpg?t=1718709004",
        "banner145": "https://dbxce1spal1df.cloudfront.net/018d937f-4adb-73a6-a9e5-94ff5f2b847b/banner145.jpg?t=1718709005",
        "banner300": "https://dbxce1spal1df.cloudfront.net/018d937f-4adb-73a6-a9e5-94ff5f2b847b/banner300.jpg?t=1718709005",
        "banner400": "https://dbxce1spal1df.cloudfront.net/018d937f-4adb-73a6-a9e5-94ff5f2b847b/banner400.jpg?t=1718709006",
        "banner600": "https://dbxce1spal1df.cloudfront.net/018d937f-4adb-73a6-a9e5-94ff5f2b847b/banner600.jpg?t=1718709007"
    },
    "earlyAccess": false,
    "achievements": true,
    "tradingCards": false,
    "appid": 2552430,
    "tags": [
        "Action",
        "RPG",
        "Adventure",
        "JRPG",
        "Action-Adventure"
    ],
    "releaseDate": "2021-03-30",
    "developers": [
        {
            "id": 101,
            "name": "Square Enix"
        }
    ],
    "publishers": [
        {
            "id": 101,
            "name": "Square Enix"
        }
    ],
    "reviews": [
        {
            "score": 70,
            "source": "Steam",
            "count": 1639,
            "url": "https://store.steampowered.com/app/2552430/"
        }
    ],
    "stats": {
        "rank": 2802,
        "waitlisted": 4636,
        "collected": 1264
    },
    "players": {
        "recent": 6525,
        "day": 7051,
        "week": 9013,
        "peak": 11074
    },
    "urls": {
        "game": "https://isthereanydeal.com/game/kingdom-hearts-hd-1-5-and-2-5-remix/"
    }
}
""".data(using: .utf8)!

let shopsJSON =
"""
[
    {
        "id": 19,
        "title": "2game",
        "deals": 55,
        "games": 3931,
        "update": "2024-06-26T04:17:59+02:00"
    },
    {
        "id": 2,
        "title": "AllYouPlay",
        "deals": 336,
        "games": 4346,
        "update": "2024-06-26T21:36:06+02:00"
    },
    {
        "id": 3,
        "title": "Amazon",
        "deals": 142,
        "games": 4618,
        "update": "2024-06-26T22:12:33+02:00"
    },
    {
        "id": 4,
        "title": "Blizzard",
        "deals": 99,
        "games": 573,
        "update": "2024-06-26T21:21:16+02:00"
    },
    {
        "id": 13,
        "title": "DLGamer",
        "deals": 2819,
        "games": 4265,
        "update": "2024-06-26T04:17:22+02:00"
    },
    {
        "id": 15,
        "title": "Dreamgame",
        "deals": 42,
        "games": 1655,
        "update": "2024-06-26T22:17:17+02:00"
    },
    {
        "id": 52,
        "title": "EA Store",
        "deals": 6,
        "games": 532,
        "update": "2024-06-26T22:25:44+02:00"
    },
    {
        "id": 16,
        "title": "Epic Game Store",
        "deals": 450,
        "games": 9382,
        "update": "2024-06-26T22:00:23+02:00"
    },
    {
        "id": 67,
        "title": "eTail.Market",
        "deals": 1974,
        "games": 3205,
        "update": "2024-06-26T22:17:35+02:00"
    },
    {
        "id": 6,
        "title": "Fanatical",
        "deals": 8135,
        "games": 12255,
        "update": "2024-06-26T22:15:56+02:00"
    },
    {
        "id": 17,
        "title": "FireFlower",
        "deals": 1,
        "games": 238,
        "update": "2024-06-26T22:16:16+02:00"
    },
    {
        "id": 20,
        "title": "GameBillet",
        "deals": 6218,
        "games": 6529,
        "update": "2024-06-26T18:16:27+02:00"
    },
    {
        "id": 68,
        "title": "Gamer Thor",
        "deals": 1102,
        "games": 3097,
        "update": "2024-06-26T16:26:10+02:00"
    },
    {
        "id": 24,
        "title": "GamersGate",
        "deals": 715,
        "games": 8609,
        "update": "2024-06-26T21:55:42+02:00"
    },
    {
        "id": 25,
        "title": "Gamesload",
        "deals": 1383,
        "games": 2581,
        "update": "2024-06-26T22:10:47+02:00"
    },
    {
        "id": 27,
        "title": "GamesPlanet DE",
        "deals": 5737,
        "games": 6436,
        "update": "2024-06-26T22:15:43+02:00"
    },
    {
        "id": 28,
        "title": "GamesPlanet FR",
        "deals": 5764,
        "games": 6469,
        "update": "2024-06-26T22:15:34+02:00"
    },
    {
        "id": 26,
        "title": "GamesPlanet UK",
        "deals": 5723,
        "games": 6460,
        "update": "2024-06-26T22:15:26+02:00"
    },
    {
        "id": 29,
        "title": "GamesPlanet US",
        "deals": 6064,
        "games": 6809,
        "update": "2024-06-26T22:15:49+02:00"
    },
    {
        "id": 35,
        "title": "GOG",
        "deals": 6575,
        "games": 9555,
        "update": "2024-06-26T22:16:55+02:00"
    },
    {
        "id": 36,
        "title": "GreenManGaming",
        "deals": 1425,
        "games": 10676,
        "update": "2024-06-26T20:30:39+02:00"
    },
    {
        "id": 37,
        "title": "Humble Store",
        "deals": 4402,
        "games": 11756,
        "update": "2024-06-26T22:18:07+02:00"
    },
    {
        "id": 42,
        "title": "IndieGala Store",
        "deals": 1325,
        "games": 9345,
        "update": "2024-06-26T22:17:00+02:00"
    },
    {
        "id": 65,
        "title": "JoyBuggy",
        "deals": 3372,
        "games": 3421,
        "update": "2024-06-26T21:17:16+02:00"
    },
    {
        "id": 47,
        "title": "MacGameStore",
        "deals": 584,
        "games": 4792,
        "update": "2024-06-26T20:55:26+02:00"
    },
    {
        "id": 48,
        "title": "Microsoft Store",
        "deals": 48,
        "games": 975,
        "update": "2024-06-26T21:30:36+02:00"
    },
    {
        "id": 49,
        "title": "Newegg",
        "deals": 249,
        "games": 5249,
        "update": "2024-06-26T20:26:50+02:00"
    },
    {
        "id": 66,
        "title": "Noctre",
        "deals": 257,
        "games": 3315,
        "update": "2024-06-26T21:56:07+02:00"
    },
    {
        "id": 50,
        "title": "Nuuvem",
        "deals": 1743,
        "games": 3142,
        "update": "2024-06-26T22:16:02+02:00"
    },
    {
        "id": 60,
        "title": "Square Enix",
        "deals": 52,
        "games": 162,
        "update": "2024-06-26T04:18:11+02:00"
    },
    {
        "id": 61,
        "title": "Steam",
        "deals": 20732,
        "games": 184796,
        "update": "2024-06-26T22:15:27+02:00"
    },
    {
        "id": 62,
        "title": "Ubisoft Store",
        "deals": 104,
        "games": 671,
        "update": "2024-06-26T22:25:30+02:00"
    },
    {
        "id": 63,
        "title": "Voidu",
        "deals": 0,
        "games": 4488,
        "update": "2024-06-07T23:16:56+02:00"
    },
    {
        "id": 64,
        "title": "WinGameStore",
        "deals": 1706,
        "games": 5746,
        "update": "2024-06-26T20:55:18+02:00"
    }
]
""".data(using: .utf8)!

let pricesJSON =
"""
[
    {
        "id": "018d937f-4adb-73a6-a9e5-94ff5f2b847b",
        "deals": [
            {
                "shop": {
                    "id": 61,
                    "name": "Steam"
                },
                "price": {
                    "amount": 34.49,
                    "amountInt": 3449,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 49.99,
                    "amountInt": 4999,
                    "currency": "USD"
                },
                "cut": 31,
                "voucher": null,
                "storeLow": {
                    "amount": 34.49,
                    "amountInt": 3449,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 19.99,
                    "amountInt": 1999,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-13T18:03:04+02:00",
                "expiry": "2024-06-27T19:00:03+02:00",
                "url": "https://itad.link/01901254-33a3-733b-9549-a09c8a663a9b/"
            },
            {
                "shop": {
                    "id": 37,
                    "name": "Humble Store"
                },
                "price": {
                    "amount": 34.49,
                    "amountInt": 3449,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 49.99,
                    "amountInt": 4999,
                    "currency": "USD"
                },
                "cut": 31,
                "voucher": null,
                "storeLow": {
                    "amount": 34.49,
                    "amountInt": 3449,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 19.99,
                    "amountInt": 1999,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-13T19:07:11+02:00",
                "expiry": "2024-07-11T19:00:00+02:00",
                "url": "https://itad.link/01901291-5020-72a1-aa24-a7b0ca415c21/"
            },
            {
                "shop": {
                    "id": 36,
                    "name": "GreenManGaming"
                },
                "price": {
                    "amount": 34.49,
                    "amountInt": 3449,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 49.99,
                    "amountInt": 4999,
                    "currency": "USD"
                },
                "cut": 31,
                "voucher": null,
                "storeLow": {
                    "amount": 34.49,
                    "amountInt": 3449,
                    "currency": "USD"
                },
                "historyLow": {
                    "amount": 19.99,
                    "amountInt": 1999,
                    "currency": "USD"
                },
                "flag": "S",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-13T19:11:10+02:00",
                "expiry": null,
                "url": "https://itad.link/018f9620-1da5-72a1-b85e-a91a0954bb7e/"
            }
        ]
    }
]
""".data(using: .utf8)!

let gameDetailJSON =
"""
{
    "2552430": {
        "success": true,
        "data": {
            "type": "game",
            "name": "KINGDOM HEARTS -HD 1.5+2.5 ReMIX-",
            "steam_appid": 2552430,
            "required_age": 0,
            "is_free": false,
            "controller_support": "full",
            "detailed_description": "<h1>KINGDOM HEARTS INTEGRUM MASTERPIECE</h1><p><img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/Main-Capsule_en.png?t=1719584592\" /><br>※The items in this bundle are also available as individual purchases. <br><br>Experience the full story of KINGDOM HEARTS! The journey begins in KINGDOM HEARTS -HD 1.5+2.5 ReMIX- as Sora, Donald, and Goofy battle the Heartless, making friends and having spectacular adventures along the way. The story culminates in KINGDOM HEARTS III + Re Mind, where our heroes take on tremendous challenges and persevere against the darkness threatening iconic Disney and Pixar worlds.</p><br><h1>About the Game</h1><img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/Sollertia_GIFs_KH1_01.gif?t=1719584592\" /><br>KINGDOM HEARTS -HD 1.5+2.5 ReMIX- is an essential collection of the first six stories in the KINGDOM HEARTS series, a collaboration between Disney and SQUARE ENIX. Wield the legendary Keyblade and unlock the true power of friendship as you explore Disney worlds and defend them from darkness.<br><br><ul class=\"bb_ul\"><li>KINGDOM HEARTS FINAL MIX<br></li><li>KINGDOM HEARTS Re:Chain of Memories<br></li><li>KINGDOM HEARTS II FINAL MIX<br></li><li>KINGDOM HEARTS 358/2 Days (HD cutscene compilation)<br></li><li>KINGDOM HEARTS Birth by Sleep FINAL MIX<br></li><li>KINGDOM HEARTS Re:coded (HD cutscene compilation)</li></ul><br><img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/Sollertia_GIFs_KH2_01.gif?t=1719584592\" /><br><br>Enhanced backgrounds make this collection more stunning than ever before. Start your KINGDOM HEARTS journey now!<br><img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/in-text-benner.gif?t=1719584592\" /><br><br>This game is available in two versions: Japanese and International.<br>Select your preferred language via the Steam launcher by right-clicking the title, then selecting &quot;Properties&quot; followed by &quot;General&quot;.<br><br>NOTICE: Save data cannot be transferred between the Japanese and International versions.<br><br>An issue with the below GPUs may arise during gameplay preventing progress in the listed titles. The timeline for a potential fix is currently being determined. <br>Please check your device before purchasing this product.<br>Affected GPUs: <br>　- AMD Radeon RX 7800 XT<br>　- AMD Radeon RX 7900 XT<br>Affected titles:<br>　- KINGDOM HEARTS FINAL MIX<br>　- KINGDOM HEARTS II FINAL MIX<br>　- KINGDOM HEARTS Birth by Sleep FINAL MIX",
            "about_the_game": "<img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/Sollertia_GIFs_KH1_01.gif?t=1719584592\" /><br>KINGDOM HEARTS -HD 1.5+2.5 ReMIX- is an essential collection of the first six stories in the KINGDOM HEARTS series, a collaboration between Disney and SQUARE ENIX. Wield the legendary Keyblade and unlock the true power of friendship as you explore Disney worlds and defend them from darkness.<br><br><ul class=\"bb_ul\"><li>KINGDOM HEARTS FINAL MIX<br></li><li>KINGDOM HEARTS Re:Chain of Memories<br></li><li>KINGDOM HEARTS II FINAL MIX<br></li><li>KINGDOM HEARTS 358/2 Days (HD cutscene compilation)<br></li><li>KINGDOM HEARTS Birth by Sleep FINAL MIX<br></li><li>KINGDOM HEARTS Re:coded (HD cutscene compilation)</li></ul><br><img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/Sollertia_GIFs_KH2_01.gif?t=1719584592\" /><br><br>Enhanced backgrounds make this collection more stunning than ever before. Start your KINGDOM HEARTS journey now!<br><img src=\"https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/extras/in-text-benner.gif?t=1719584592\" /><br><br>This game is available in two versions: Japanese and International.<br>Select your preferred language via the Steam launcher by right-clicking the title, then selecting &quot;Properties&quot; followed by &quot;General&quot;.<br><br>NOTICE: Save data cannot be transferred between the Japanese and International versions.<br><br>An issue with the below GPUs may arise during gameplay preventing progress in the listed titles. The timeline for a potential fix is currently being determined. <br>Please check your device before purchasing this product.<br>Affected GPUs: <br>　- AMD Radeon RX 7800 XT<br>　- AMD Radeon RX 7900 XT<br>Affected titles:<br>　- KINGDOM HEARTS FINAL MIX<br>　- KINGDOM HEARTS II FINAL MIX<br>　- KINGDOM HEARTS Birth by Sleep FINAL MIX",
            "short_description": "KINGDOM HEARTS -HD 1.5+2.5 ReMIX- is an HD remastered collection of 6 unforgettable KINGDOM HEARTS experiences. Take up your Keyblade to save the Disney worlds from darkness.",
            "supported_languages": "English<strong>*</strong>, French, Italian, German, Spanish - Spain, Japanese<strong>*</strong><br><strong>*</strong>languages with full audio support",
            "reviews": "“The definitive Kingdom Hearts experience”<br>9/10 – <a href=\"https://steamcommunity.com/linkfilter/?u=https%3A%2F%2Fwww.sportskeeda.com%2Fesports%2Fkingdom-hearts-integrum-masterpiece-pc-review-the-definitive-kingdom-hearts-experience\" target=\"_blank\" rel=\" noopener\"  >Sportskeeda</a><br><br>“a wonderful way to continue the saga”<br>4/5 – <a href=\"https://steamcommunity.com/linkfilter/?u=https%3A%2F%2Fsteamdeckhq.com%2Fgame-reviews%2Fkingdom-hearts-hd-1-52-5-remix%2F\" target=\"_blank\" rel=\" noopener\"  >Steam Deck HQ</a><br>",
            "header_image": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/header.jpg?t=1719584592",
            "capsule_image": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/capsule_231x87.jpg?t=1719584592",
            "capsule_imagev5": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/capsule_184x69.jpg?t=1719584592",
            "website": "https://www.kingdomhearts.com/",
            "pc_requirements": {
                "minimum": "<strong>Minimum:</strong><br><ul class=\"bb_ul\"><li>Requires a 64-bit processor and operating system<br></li><li><strong>OS:</strong> Windows 10 64-bit (ver.1909 or later)<br></li><li><strong>Processor:</strong> Intel® Core™ i3-3210 / AMD A8-7600<br></li><li><strong>Memory:</strong> 4 GB RAM<br></li><li><strong>Graphics:</strong> NVIDIA® GeForce® GTX 750 / AMD Radeon™ RX 460<br></li><li><strong>DirectX:</strong> Version 11<br></li><li><strong>Storage:</strong> 60 GB available space<br></li><li><strong>Additional Notes:</strong> 30FPS @1280×720</li></ul>",
                "recommended": "<strong>Recommended:</strong><br><ul class=\"bb_ul\"><li>Requires a 64-bit processor and operating system<br></li><li><strong>OS:</strong> Windows 10 64-bit (ver.1909 or later)<br></li><li><strong>Processor:</strong> Intel® Core™ i3-3210 / AMD A8-7600<br></li><li><strong>Memory:</strong> 8 GB RAM<br></li><li><strong>Graphics:</strong> NVIDIA® GeForce® GTX 750 / AMD Radeon™ RX 460<br></li><li><strong>DirectX:</strong> Version 11<br></li><li><strong>Storage:</strong> 60 GB available space<br></li><li><strong>Additional Notes:</strong> 60FPS @1920×1080</li></ul>"
            },
            "mac_requirements": {
                "minimum": "<strong>Minimum:</strong><br><ul class=\"bb_ul\"></ul>",
                "recommended": "<strong>Recommended:</strong><br><ul class=\"bb_ul\"></ul>"
            },
            "linux_requirements": {
                "minimum": "<strong>Minimum:</strong><br><ul class=\"bb_ul\"></ul>",
                "recommended": "<strong>Recommended:</strong><br><ul class=\"bb_ul\"></ul>"
            },
            "legal_notice": "© Disney © Disney/Pixar Developed by SQUARE ENIX.",
            "developers": [
                "Square Enix"
            ],
            "publishers": [
                "Square Enix"
            ],
            "price_overview": {
                "currency": "USD",
                "initial": 4999,
                "final": 3449,
                "discount_percent": 31,
                "initial_formatted": "$49.99",
                "final_formatted": "$34.49"
            },
            "packages": [
                916836,
                1000794
            ],
            "package_groups": [
                {
                    "name": "default",
                    "title": "Buy KINGDOM HEARTS -HD 1.5+2.5 ReMIX-",
                    "description": "",
                    "selection_text": "Select a purchase option",
                    "save_text": "",
                    "display_type": 0,
                    "is_recurring_subscription": "false",
                    "subs": [
                        {
                            "packageid": 916836,
                            "percent_savings_text": "-31% ",
                            "percent_savings": 0,
                            "option_text": "KINGDOM HEARTS -HD 1.5+2.5 ReMIX- - <span class=\"discount_original_price\">$49.99</span> $34.49",
                            "option_description": "",
                            "can_get_free_license": "0",
                            "is_free_license": false,
                            "price_in_cents_with_discount": 3449
                        },
                        {
                            "packageid": 1000794,
                            "percent_savings_text": "-31% ",
                            "percent_savings": 0,
                            "option_text": "KINGDOM HEARTS INTEGRUM MASTERPIECE - <span class=\"discount_original_price\">$99.99</span> $68.99",
                            "option_description": "",
                            "can_get_free_license": "0",
                            "is_free_license": false,
                            "price_in_cents_with_discount": 6899
                        }
                    ]
                }
            ],
            "platforms": {
                "windows": true,
                "mac": false,
                "linux": false
            },
            "categories": [
                {
                    "id": 2,
                    "description": "Single-player"
                },
                {
                    "id": 22,
                    "description": "Steam Achievements"
                },
                {
                    "id": 28,
                    "description": "Full controller support"
                },
                {
                    "id": 23,
                    "description": "Steam Cloud"
                },
                {
                    "id": 62,
                    "description": "Family Sharing"
                }
            ],
            "genres": [
                {
                    "id": "1",
                    "description": "Action"
                },
                {
                    "id": "25",
                    "description": "Adventure"
                },
                {
                    "id": "3",
                    "description": "RPG"
                }
            ],
            "screenshots": [
                {
                    "id": 0,
                    "path_thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_7fec87ad80856a7a3f4cf487cd70ce3a2ad8b280.600x338.jpg?t=1719584592",
                    "path_full": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_7fec87ad80856a7a3f4cf487cd70ce3a2ad8b280.1920x1080.jpg?t=1719584592"
                },
                {
                    "id": 1,
                    "path_thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_9cd43d79e8206460e989d653fa4461c1c9cfc849.600x338.jpg?t=1719584592",
                    "path_full": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_9cd43d79e8206460e989d653fa4461c1c9cfc849.1920x1080.jpg?t=1719584592"
                },
                {
                    "id": 2,
                    "path_thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_44a263601363334fdd598144813d2a96f0b030e1.600x338.jpg?t=1719584592",
                    "path_full": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_44a263601363334fdd598144813d2a96f0b030e1.1920x1080.jpg?t=1719584592"
                },
                {
                    "id": 3,
                    "path_thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_65f24887aba04097139dc3553532da7d374e30af.600x338.jpg?t=1719584592",
                    "path_full": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_65f24887aba04097139dc3553532da7d374e30af.1920x1080.jpg?t=1719584592"
                },
                {
                    "id": 4,
                    "path_thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_f02606d4b776c08ec208fe0eb69f245cf613b0ad.600x338.jpg?t=1719584592",
                    "path_full": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_f02606d4b776c08ec208fe0eb69f245cf613b0ad.1920x1080.jpg?t=1719584592"
                },
                {
                    "id": 5,
                    "path_thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_90018480206111722fc95718bbf61ac5683d25d2.600x338.jpg?t=1719584592",
                    "path_full": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/ss_90018480206111722fc95718bbf61ac5683d25d2.1920x1080.jpg?t=1719584592"
                }
            ],
            "movies": [
                {
                    "id": 257030994,
                    "name": "ESRB EN Launch",
                    "thumbnail": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/257030994/movie.293x165.jpg?t=1718294236",
                    "webm": {
                        "480": "http://cdn.akamai.steamstatic.com/steam/apps/257030994/movie480_vp9.webm?t=1718294236",
                        "max": "http://cdn.akamai.steamstatic.com/steam/apps/257030994/movie_max_vp9.webm?t=1718294236"
                    },
                    "mp4": {
                        "480": "http://cdn.akamai.steamstatic.com/steam/apps/257030994/movie480.mp4?t=1718294236",
                        "max": "http://cdn.akamai.steamstatic.com/steam/apps/257030994/movie_max.mp4?t=1718294236"
                    },
                    "highlight": true
                }
            ],
            "recommendations": {
                "total": 3055
            },
            "achievements": {
                "total": 197,
                "highlighted": [
                    {
                        "name": "Proud Player",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/0f80170c30ec5de91fe4ec9ef621a2f3c1d4208b.jpg"
                    },
                    {
                        "name": "Final Mix Master",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/29f5502da37723c4842c2fe751bf419d46f9ab6a.jpg"
                    },
                    {
                        "name": "Novice Player",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/be89b9ccdf8dc294e780ba376644decbe549244c.jpg"
                    },
                    {
                        "name": "Unchanging Armor",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/1b231e4afc39f29b08d2fdd9f5c06cd9836233a6.jpg"
                    },
                    {
                        "name": "Undefeated",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/b6b88abcd892e32407caddbb8b3b67470a204324.jpg"
                    },
                    {
                        "name": "Speedster",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/2b55ceea6149e90d863c2dfb6f7f383deebb3ee8.jpg"
                    },
                    {
                        "name": "He Who Doesn't Exist",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/dd37062ddcce82c9f35dfe3fae9b82209a44b2fe.jpg"
                    },
                    {
                        "name": "The Cloaked Shadow",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/a398bbad0f9bd2ae57dc332b1e271337394c16f5.jpg"
                    },
                    {
                        "name": "The Sandy Blade",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/4736c7659ff78f2b1bd7e4a36440fceca6ff19ac.jpg"
                    },
                    {
                        "name": "Novice Hero",
                        "path": "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/2552430/868e98604ed85901c66dfdc19a1166d3c086e797.jpg"
                    }
                ]
            },
            "release_date": {
                "coming_soon": false,
                "date": "Jun 13, 2024"
            },
            "support_info": {
                "url": "https://support.square-enix-games.com/",
                "email": ""
            },
            "background": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/page_bg_generated_v6b.jpg?t=1719584592",
            "background_raw": "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/page.bg.jpg?t=1719584592",
            "content_descriptors": {
                "ids": [],
                "notes": null
            },
            "ratings": {
                "esrb": {
                    "rating": "e10",
                    "descriptors": "Fantasy Violence\r\nMild Blood\r\nUse of Alcohol"
                },
                "pegi": {
                    "rating": "12",
                    "descriptors": "Violence"
                },
                "usk": {
                    "rating": "6"
                },
                "cero": {
                    "rating": "a"
                },
                "csrr": {
                    "rating": "G"
                },
                "oflc": {
                    "rating": "pg",
                    "descriptors": "Mild fantasy violence"
                },
                "kgrb": {
                    "rating": "12",
                    "descriptors": "폭력성"
                },
                "dejus": {
                    "rating_generated": "1",
                    "rating": "10",
                    "required_age": "10",
                    "banned": "0",
                    "use_age_gate": "0",
                    "descriptors": "Violência"
                },
                "steam_germany": {
                    "rating_generated": "1",
                    "rating": "12",
                    "required_age": "12",
                    "banned": "0",
                    "use_age_gate": "0",
                    "descriptors": "Gewalt"
                }
            }
        }
    }
}
""".data(using: .utf8)!

let priceOverviewJSON =
"""
{
    "prices": [
        {
            "id": "018d937f-4adb-73a6-a9e5-94ff5f2b847b",
            "current": {
                "shop": {
                    "id": 36,
                    "name": "GreenManGaming"
                },
                "price": {
                    "amount": 29.32,
                    "amountInt": 2932,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 49.99,
                    "amountInt": 4999,
                    "currency": "USD"
                },
                "cut": 41,
                "voucher": "SIZZLE15",
                "flag": "S",
                "drm": [
                    {
                        "id": 61,
                        "name": "Steam"
                    }
                ],
                "platforms": [
                    {
                        "id": 1,
                        "name": "Windows"
                    }
                ],
                "timestamp": "2024-06-13T19:11:10+02:00",
                "expiry": null,
                "url": "https://itad.link/018f9620-1da5-72a1-b85e-a91a0954bb7e/"
            },
            "lowest": {
                "shop": {
                    "id": 16,
                    "name": "Epic Game Store"
                },
                "price": {
                    "amount": 19.99,
                    "amountInt": 1999,
                    "currency": "USD"
                },
                "regular": {
                    "amount": 49.99,
                    "amountInt": 4999,
                    "currency": "USD"
                },
                "cut": 60,
                "timestamp": "2023-12-13T17:01:10+01:00"
            },
            "bundled": 0,
            "urls": {
                "game": "https://isthereanydeal.com/game/id:018d937f-4adb-73a6-a9e5-94ff5f2b847b/"
            }
        }
    ],
    "bundles": []
}
""".data(using: .utf8)!

let giveawaysJSON =
"""
[
    {
        "id": 2629,
        "title": "ConflictCraft 2 (IndieGala) Giveaway",
        "worth": "$9.99",
        "thumbnail": "https://www.gamerpower.com/offers/1/65315b4eae7d3.jpg",
        "image": "https://www.gamerpower.com/offers/1b/65315b4eae7d3.jpg",
        "description": "Download ConflictCraft 2 - Game of the Year Edition for free on IndieGala! Conflict Craft 2 is a indie strategy game with 53 levels to complete.",
        "instructions": "1. Login into your free IndieGala account.me.",
        "open_giveaway_url": "https://www.gamerpower.com/open/conflictcraft-2-indiegala-giveaway",
        "published_date": "2024-08-09 09:19:48",
        "type": "Game",
        "platforms": "PC, DRM-Free",
        "end_date": "N/A",
        "users": 3600,
        "status": "Active",
        "gamerpower_url": "https://www.gamerpower.com/conflictcraft-2-indiegala-giveaway",
        "open_giveaway": "https://www.gamerpower.com/open/conflictcraft-2-indiegala-giveaway"
    },
    {
        "id": 2910,
        "title": "Apex Legends: Conduit Free Unlock Bundle Giveaway",
        "worth": "N/A",
        "thumbnail": "https://www.gamerpower.com/offers/1/66b4e1107df1d.jpg",
        "image": "https://www.gamerpower.com/offers/1b/66b4e1107df1d.jpg",
        "description": ".",
        "open_giveaway_url": "https://www.gamerpower.com/open/apex-legends-conduit-free-unlock-bundle-giveaway",
        "published_date": "2024-08-08 11:15:28",
        "type": "DLC",
        "platforms": "PC, Epic Games Store",
        "end_date": "2024-08-15 23:59:00",
        "users": 1170,
        "status": "Active",
        "gamerpower_url": "https://www.gamerpower.com/apex-legends-conduit-free-unlock-bundle-giveaway",
        "open_giveaway": "https://www.gamerpower.com/open/apex-legends-conduit-free-unlock-bundle-giveaway"
    }
]
""".data(using: .utf8)!

let steamHistory =
"""
[
    {
        "timestamp": "2024-08-27T19:18:21+02:00",
        "shop": {
            "id": 61,
            "name": "Steam"
        },
        "deal": {
            "price": {
                "amount": 34.49,
                "amountInt": 3449,
                "currency": "USD"
            },
            "regular": {
                "amount": 49.99,
                "amountInt": 4999,
                "currency": "USD"
            },
            "cut": 31
        }
    },
    {
        "timestamp": "2024-07-11T20:51:36+02:00",
        "shop": {
            "id": 61,
            "name": "Steam"
        },
        "deal": {
            "price": {
                "amount": 49.99,
                "amountInt": 4999,
                "currency": "USD"
            },
            "regular": {
                "amount": 49.99,
                "amountInt": 4999,
                "currency": "USD"
            },
            "cut": 0
        }
    },
    {
        "timestamp": "2024-06-13T18:03:04+02:00",
        "shop": {
            "id": 61,
            "name": "Steam"
        },
        "deal": {
            "price": {
                "amount": 34.49,
                "amountInt": 3449,
                "currency": "USD"
            },
            "regular": {
                "amount": 49.99,
                "amountInt": 4999,
                "currency": "USD"
            },
            "cut": 31
        }
    }
]
""".data(using: .utf8)!
