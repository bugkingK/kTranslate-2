//
//  Main_ChooseLanguage.swift
//  Translate-Text
//
//  Created by moon on 04/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Cocoa
import RxSwift

class Main_ChooseLanguage: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if m_arr_datas == nil {
            loadData()
            self.m_cv_main.reloadData()
        }
        let indexPath = IndexPath(item: self.m_n_select, section: 0)
        self.m_cv_main.scrollToItems(at: [indexPath], scrollPosition: .centeredVertically)
    }
    
    @IBOutlet weak var m_cv_main: NSCollectionView!
    fileprivate var m_arr_datas:GoogleTranslation.SupportData?
    fileprivate var m_sel_block:((_ sel:(String, String?))->())? = nil
    
    fileprivate var m_str_select:String? = nil
    fileprivate var m_n_select:Int = 0
    fileprivate var m_b_source:Bool = false
    fileprivate let m_dispose_bag:DisposeBag = DisposeBag()
    
    fileprivate func setupLayout() {
        DBLanguages.setup()
        m_cv_main.delegate = self
        m_cv_main.dataSource = self
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: self.view.frame.width/4, height: 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        m_cv_main.collectionViewLayout = flowLayout
        self.m_cv_main.reloadData()
    }
    
    public func setup(select:String?, isSource:Bool, selBlock:((_ sel:(String, String?))->())? = nil) {
        m_sel_block = selBlock
        m_b_source = isSource
        m_str_select = select
        loadData()
    }
    
    public func loadData() {
        let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
        let target = isKorean ? "ko" : "en"
        guard let obs = GoogleTranslation.supportLanguages(target: target) else { return }
        obs.subscribe(onNext: { (datas) in
            for lang in datas.languages {
                print("\(lang.key!),")
//                print("LanguageData(key: \"\(lang.key!)\", name: \"\(lang.name)\"),")
            }
            var v_datas = datas
            if self.m_b_source {
                let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
                let sourceName = isKorean ? "언어감지" : "Detect"
                v_datas.languages.insert((name: sourceName, key: nil), at: 0)
            }
            
            self.m_arr_datas = v_datas
            for (idx, data) in v_datas.languages.enumerated() {
                if data.key == self.m_str_select {
                    self.m_n_select = idx
                }
            }
        }, onError: { (err) in
            print("supportLanguages err \(err.localizedDescription)")
        })
        .disposed(by: m_dispose_bag)
    }
    
    @objc fileprivate func onClickBtnTitle(_ sender:NSButton) {
        let item = sender.tag
        m_n_select = item
        guard let ret_val = m_arr_datas?.languages[item] else { return }
        m_sel_block?(ret_val)
    }
    
}

extension Main_ChooseLanguage: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return m_arr_datas?.languages.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChooseLanguageCell"), for: indexPath) as? ChooseLanguageCell,
              let language = m_arr_datas?.languages[indexPath.item] else {
            return NSCollectionViewItem.init()
        }

        let item = indexPath.item
        cell.btnTitle.title = language.name
        cell.btnTitle.target = self
        cell.btnTitle.tag = item
        cell.btnTitle.action = #selector(onClickBtnTitle(_:))
        cell.btnTitle.backgroundColor = item == m_n_select ? .hex_EE768A : .white
        cell.btnTitle.textColor = item == m_n_select ? .white : .hex_222428
        return cell
    }
}

class ChooseLanguageCell: NSCollectionViewItem {
    @IBOutlet weak var btnTitle: CustomButton!
}


class SupportLang: NSObject {
    
    
    func test(target:String) -> String {
        switch target {
        case "gl": return "갈리시아어"
        case "gu": return "구자라트어"
        case "el": return "그리스어"
        case "nl": return "네덜란드어"
        case "ne": return "네팔어"
        case "no": return "노르웨이어"
        case "da": return "덴마크어"
        case "de": return "독일어"
        case "lo": return "라오어"
        case "lv": return "라트비아어"
        case "la": return "라틴어"
        case "ru": return "러시아어"
        case "ro": return "루마니아어"
        case "lb": return "룩셈부르크어"
        case "lt": return "리투아니아어"
        case "mr": return "마라티어"
        case "mi": return "마오리어"
        case "mk": return "마케도니아어"
        case "mg": return "말라가시어"
        case "ml": return "말라얄람어"
        case "ms": return "말레이어"
        case "mt": return "몰타어"
        case "mn": return "몽골어"
        case "hmn": return "몽어"
        case "my": return "미얀마어 (버마어)"
        case "eu": return "바스크어"
        case "vi": return "베트남어"
        case "be": return "벨라루스어"
        case "bn": return "벵골어"
        case "bs": return "보스니아어"
        case "bg": return "불가리아어"
        case "sm": return "사모아어"
        case "sr": return "세르비아어"
        case "ceb": return "세부아노"
        case "st": return "세소토어"
        case "so": return "소말리아어"
        case "sn": return "쇼나어"
        case "su": return "순다어"
        case "sw": return "스와힐리어"
        case "sv": return "스웨덴어"
        case "gd": return "스코틀랜드 게일어"
        case "es": return "스페인어"
        case "sk": return "슬로바키아어"
        case "sl": return "슬로베니아어"
        case "sd": return "신디어"
        case "si": return "신할라어"
        case "ar": return "아랍어"
        case "hy": return "아르메니아어"
        case "is": return "아이슬란드어"
        case "ht": return "아이티 크리올어"
        case "ga": return "아일랜드어"
        case "az": return "아제르바이잔어"
        case "af": return "아프리칸스어"
        case "sq": return "알바니아어"
        case "am": return "암하라어"
        case "et": return "에스토니아어"
        case "eo": return "에스페란토어"
        case "en": return "영어"
        case "yo": return "요루바어"
        case "ur": return "우르두어"
        case "uz": return "우즈베크어"
        case "uk": return "우크라이나어"
        case "cy": return "웨일즈어"
        case "ig": return "이그보어"
        case "yi": return "이디시어"
        case "it": return "이탈리아어"
        case "id": return "인도네시아어"
        case "ja": return "일본어"
        case "jw": return "자바어"
        case "ka": return "조지아어"
        case "zu": return "줄루어"
        case "zh": return "중국어(간체)"
        case "zh-TW": return "중국어(번체)"
        case "ny": return "체와어"
        case "cs": return "체코어"
        case "kk": return "카자흐어"
        case "ca": return "카탈로니아어"
        case "kn": return "칸나다어"
        case "co": return "코르시카어"
        case "xh": return "코사어"
        case "ku": return "쿠르드어"
        case "hr": return "크로아티아어"
        case "km": return "크메르어"
        case "ky": return "키르기스어"
        case "tl": return "타갈로그어"
        case "ta": return "타밀어"
        case "tg": return "타지크어"
        case "th": return "태국어"
        case "tr": return "터키어"
        case "te": return "텔루구어"
        case "ps": return "파슈토어"
        case "pa": return "펀자브어"
        case "fa": return "페르시아어"
        case "pt": return "포르투갈어"
        case "pl": return "폴란드어"
        case "fr": return "프랑스어"
        case "fy": return "프리지아어"
        case "fi": return "핀란드어"
        case "haw": return "하와이어"
        case "ha": return "하우사어"
        case "ko": return "한국어"
        case "hu": return "헝가리어"
        case "iw": return "히브리어"
        case "hi": return "힌디어"
        default : return ""
        }
    }
}
