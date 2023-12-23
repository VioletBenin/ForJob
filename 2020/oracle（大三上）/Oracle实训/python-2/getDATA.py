# -- coding:UTF-8 --
from bs4 import BeautifulSoup
import requests
import re
import json
import random
import pandas as pd
import traceback

IPRegular = r"(([1-9]?\d|1\d{2}|2[0-4]\d|25[0-5]).){3}([1-9]?\d|1\d{2}|2[0-4]\d|25[0-5])"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36 Edg/87.0.664.66",
    "cookie": "t=a8fa17797757291218ce092b87a92e0d; cookie2=131f38078c90976e7e0eb78e24435cc4; v=0; _tb_token_=5ae83bbbbee61; cna=ud1oGA4ypW4CARvfTnQ34rVn; xlly_s=1; _samesite_flag_=true; sgcookie=E100fRV7FPWEU3ij8Wzq9zzDDwYTeRB22B0qQCJbnJdTvtT9CJKxBxMHv78JYMkdkhlyIuFgKE66yvZfPbocYu5Q7Q%3D%3D; uc3=nk2=05heIwSeSnJ53w%3D%3D&lg2=U%2BGCWk%2F75gdr5Q%3D%3D&id2=UNaGvUsrFW%2FL5Q%3D%3D&vt3=F8dCuAMkOTo8QTBHFys%3D; csg=1439b758; lgc=%5Cu67CF%5Cu821F%5Cu67CF%5Cu821F%5Cu67CF; dnk=%5Cu67CF%5Cu821F%5Cu67CF%5Cu821F%5Cu67CF; skt=9cc02b38f6ea88f1; existShop=MTYwOTI0MTY2MQ%3D%3D; uc4=nk4=0%400SM5R7vlMOu6Dy3Mier%2FnPRW%2BCPn&id4=0%40UgGP%2BctXWfrANVeG5N%2BH8elROrf2; tracknick=%5Cu67CF%5Cu821F%5Cu67CF%5Cu821F%5Cu67CF; _cc_=UtASsssmfA%3D%3D; enc=hDNrUBXVa61M8NQBm2qN4FloVNPtzvdRYCnSo3xSDwwGNtcfwbJ25gh%2FOb2je%2BNNXdiNOHv5lCH9vXdYgoVyBw%3D%3D; mt=ci=12_1; thw=cn; hng=CN%7Czh-CN%7CCNY%7C156; _m_h5_tk=70025c605ce7b600601b9a19e021fd5e_1609275204737; _m_h5_tk_enc=8b38099bc8d94731cb3c82b013680632; uc1=cookie16=V32FPkk%2FxXMk5UvIbNtImtMfJQ%3D%3D&existShop=false&cookie14=Uoe0ZNTSi7lhPQ%3D%3D&cookie21=VT5L2FSpczFp&pas=0; l=eBxiDBPrO75ZqauxBOfwourza77OSIRAguPzaNbMiOCPOB5e5kShWZ-GQ4TwC3GVh6ovR3PWA2GQBeYBq3K-nxvtIosM_Ckmn; tfstk=caTlBgbqo3S5lpjDf4_Wsxa4c-MAaPnPFe82uEGtfxV9dYLVasxg0lo7wjX-tsqC.; isg=BPf3mOm6ZCXkeeCpKw3pTyt3hutBvMsenThVeEmkE0Yt-Bc6UYxbbrXe2limEKOW"
}


def ExtractIP(url="https://ip.ihuan.me/"):
    """
    功能：抓取IP，返回IP列表
    url：抓取IP的网站
    """
    IPs = []
    response = requests.get(url)
    soup = BeautifulSoup(response.content, "lxml")
    tds = soup.find_all("a", attrs={'target': '_blank'})
    for td in tds:
        string = td.text
        if re.search(IPRegular, string) and string not in IPs:
            IPs.append(string)
    print(IPs)
    return IPs


def Filter(mobile_infos):

    mobile_list = []
    for mobile_info in mobile_infos:
        title = mobile_info['raw_title']
        price = mobile_info['view_price']
        loc = mobile_info['item_loc'].replace(' ', '')
        shop = mobile_info['nick']
        # print(mobile_info['view_sales'])
        sales = re.search(r'(\d+.?\d*).*人付款', mobile_info['view_sales']).group(1)
        if sales[-1] == '+':  # 去掉末尾的加号
            sales = sales[:-1]
        if '万' in mobile_info['view_sales']:
            sales = float(sales) * 10000
        print(title, price, loc, shop, int(sales), mobile_info['view_sales'])
        mobile_list.append([title, price, loc, shop, int(sales)])

    return mobile_list


def Saver(mobiles):
    """
    功能：保存爬取信息
    mobiles：手机信息列表
    """
    mdata = pd.DataFrame(mobiles, columns=['手机名', '价格', '店铺位置', '店铺名', '销量'])
    mdata.to_csv('mobile_info.csv', index=False)


def Spider(page_nums=100):
    """
    功能：爬虫主程序
    page_nums：待爬取的页数
    """
    # 爬取代理IP
    IPs = ExtractIP()
    length, mobiles, i = len(IPs), [], 0
    while i < page_nums:
        try:
            print('--------------------正在爬取第{}页--------------------'.format(i + 1))
            url = "https://s.taobao.com/search?q=%E6%89%8B%E6%9C%BA&imgfile=&commend=all&ssid=s5-e&search_type=item&sourceId=tb.index&spm=a21bo.2017.201856-taobao-item.1&ie=utf8&initiative_id=tbindexz_20170306&bcoffset=3&ntoffset=0&p4ppushleft=1%2C48&data-key=s&data-value={}".format(
                i * 44)
            # 设置代理ip
            index = random.randint(0, length - 1)
            proxies = {"http": "{}:8080".format(IPs[index])}
            # 请求网页
            response = requests.get(url, headers=headers, proxies=proxies)
            # 利用正则表达式获取包含手机信息json数据
            match_obj = re.search(r'g_page_config = (.*?)};', response.text)
            # 将json对象加载为python字典
            mobile_infos = json.loads(match_obj.group(1) + '}')['mods']['itemlist']['data']['auctions']
            # 过滤出字典中的有用信息
            mobiles += Filter(mobile_infos)
            i += 1
        except Exception:
            traceback.print_exc()
            print('手机信息第{}页爬取失败'.format(i + 1))
            i += 1
    # 保存手机信息为csv文件
    Saver(mobiles)


if __name__ == "__main__":
    Spider()