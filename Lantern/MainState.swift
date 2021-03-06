//
//	MainState.swift
//	Hoverlytics
//
//	Created by Patrick Smith on 31/03/2015.
//	Copyright (c) 2015 Burnt Caramel. All rights reserved.
//

import Foundation
import LanternModel


enum SiteChoice {
	case savedSite(SiteValues)
	case custom
}

extension SiteChoice: Equatable {}

func ==(lhs: SiteChoice, rhs: SiteChoice) -> Bool {
	switch (lhs, rhs) {
	case (.custom, .custom):
		return true
	case (.savedSite(let lSite), .savedSite(let rSite)):
		return lSite.UUID == rSite.UUID
	default:
		return false
	}
}


class MainState {
	let crawlerPreferences = CrawlerPreferences.sharedCrawlerPreferences
	let browserPreferences = BrowserPreferences.sharedBrowserPreferences
	
	var siteChoice: SiteChoice = .custom {
		didSet {
			if siteChoice == oldValue {
				return
			}
			mainQueue_notify(.ChosenSiteDidChange)
		}
	}
	
	var chosenSite: SiteValues? {
		switch siteChoice {
		case .savedSite(let site):
			return site
		default:
			return nil
		}
	}
	
	var initialHost: String?
	
	enum Notification: String {
		case ChosenSiteDidChange = "LanternModel.MainState.ChosenSiteDidChangeNotification"
		
		var notificationName: String {
			return self.rawValue
		}
	}
	
	func mainQueue_notify(_ identifier: Notification, userInfo: [String:AnyObject]? = nil) {
		let nc = NotificationCenter.default
		nc.post(name: Foundation.Notification.Name(rawValue: identifier.notificationName), object: self, userInfo: userInfo)
	}
}
