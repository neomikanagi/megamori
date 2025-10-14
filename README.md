# Project Description

This project utilizes rules generated from the [AdBlock DNS Filters](https://github.com/217heidai/adblockfilters) project and performs the following tasks:
1. Every eight hours, the rules are automatically converted into a JSON file with `"version": 2` format.
2. Every eight hours, the rules are automatically converted into an SRS binary file format for use with Sing-Box.
3. A new list file is provided for Shadowrocket usage.
4. The ads-all and this list contain a significant amount of overlap. The ads-all-lite.list is the remainder of ads-all after removing these duplicates. I don't doubt the performance of mobile devices in handling this, but I have concerns about battery drain.

I would like to extend my gratitude to the original authors for their contributions. I also want to acknowledge Mosney, who created the [anti-anti-AD](https://github.com/Mosney/anti-anti-AD) project to expose the discrepancies between the actual content of anti-AD lists and the claims made by its maintainer, gentlyxu.

If you have a stance on this issue and believe that the actions of the anti-AD maintainer (gentlyxu) are correct, I kindly ask you to refrain from using my work.

## Download Links

- SRS: [https://raw.githubusercontent.com/neomikanagi/megamori/main/megamori.srs](https://raw.githubusercontent.com/neomikanagi/megamori/main/megamori.srs)
- JSON: [https://raw.githubusercontent.com/neomikanagi/megamori/main/megamori.json](https://raw.githubusercontent.com/neomikanagi/megamori/main/megamori.json)
- LIST: [https://raw.githubusercontent.com/neomikanagi/megamori/main/megamori.list](https://raw.githubusercontent.com/neomikanagi/megamori/main/megamori.list)
- LITE: [https://raw.githubusercontent.com/neomikanagi/megamori/main/ads-all-lite.list](https://raw.githubusercontent.com/neomikanagi/megamori/main/ads-all-lite.list)

HaGeZi's Pro++ DNS Blocklist: [https://raw.githubusercontent.com/neomikanagi/megamori/main/hagezi_pro_plus_adblock.srs](https://raw.githubusercontent.com/neomikanagi/megamori/main/hagezi_pro_plus_adblock.srs)
HaGeZi's Threat Intelligence Feeds DNS Blocklist: [https://raw.githubusercontent.com/neomikanagi/megamori/main/hagezi_tif_adblock.srs](https://raw.githubusercontent.com/neomikanagi/megamori/main/hagezi_tif_adblock.srs)
HaGeZi's The World's Most Abused TLDs: [https://raw.githubusercontent.com/neomikanagi/megamori/main/hagezi_spam_tlds_adblock.srs](https://raw.githubusercontent.com/neomikanagi/megamori/main/hagezi_spam_tlds_adblock.srs)
