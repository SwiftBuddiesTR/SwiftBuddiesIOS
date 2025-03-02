import SwiftUI

@propertyWrapper
public struct LocalizedString {
    public let key: String
    public init(key: String) { self.key = key }

    public var wrappedValue: Text { Text(LocalizedStringKey(self.key), bundle: .module) }
    public var projectedValue: LocalizedString { self }
    public var localized: String { NSLocalizedString(self.key, bundle: .module, comment: "") }
    public func format(_ arguments: CVarArg...) -> String { String(format: localized, arguments: arguments) }
    public func callAsFunction(_ arguments: CVarArg...) -> String { String(format: localized, arguments: arguments) }
}


// MARK: - Localized strings keys

public enum L {
    /// OK
    @LocalizedString(key: "alert.info.button.ok") public static var alert_info_button_ok: Text
    /// Merhaba SwiftBuddies!
    @LocalizedString(key: "about.title") public static var about_title: Text
    /// Welcome!
    @LocalizedString(key: "onboardingItem.FirstTitle") public static var onboardingitem_firsttitle: Text
    /// Sign in with Apple
    @LocalizedString(key: "button.sign.in.with.apple") public static var button_sign_in_with_apple: Text
    /// Edit Profile
    @LocalizedString(key: "profile.title.edit") public static var profile_title_edit: Text
    /// Filter by Repository
    @LocalizedString(key: "contributors.filter.by.repository") public static var contributors_filter_by_repository: Text
    /// Posts
    @LocalizedString(key: "profile.tab.posts") public static var profile_tab_posts: Text
    /// LinkedIn
    @LocalizedString(key: "profile.field.linkedin") public static var profile_field_linkedin: Text
    /// Profile
    @LocalizedString(key: "tab.profile") public static var tab_profile: Text
    /// GitHub
    @LocalizedString(key: "profile.field.github") public static var profile_field_github: Text
    /// Start
    @LocalizedString(key: "onboarding.StartButtonTitle") public static var onboarding_startbuttontitle: Text
    /// Buluşmalarımızı genellikle yüz yüze gerçekleştiriyoruz, ama gelecekte çevrimiçi etkinlikler de planlıyoruz. Amacımız, karşılıklı olarak pek sık karşılaşma şansımız olmayan insanları tek bir çatı altında toplamak ve ortak bir bilinç oluşturmak. Birlikte yazdığımız kodları tartışmak, çalıştığımız ortamları nasıl daha iyi hale getirebileceğimizi, şirket baskısı olmadan rahatça fikir alışverişi yapmayı ve tabii ki birbirimizi tanımak istiyoruz.
    @LocalizedString(key: "about.paragraph2") public static var about_paragraph2: Text
    /// Something went wrong, please try again.
    @LocalizedString(key: "alert.error.generic") public static var alert_error_generic: Text
    /// LinkedIn URL
    @LocalizedString(key: "textfield.linkedin.url") public static var textfield_linkedin_url: Text
    /// Contributors
    @LocalizedString(key: "tab.contributors") public static var tab_contributors: Text
    /// OK
    @LocalizedString(key: "alert.button.ok") public static var alert_button_ok: Text
    /// "SwiftBuddies, mobil ve yazılım geliştirmeye meraklı insanların bir araya geldiği sıcak bir topluluk. Özellikle iOS geliştirme konusunda yoğunlaşıyoruz. İletişimimizi genellikle Türkçe yapıyoruz, ancak İngilizce bilmeyen arkadaşlarımız da varsa onlarla İngilizce olarak da iletişim kuruyoruz."
    @LocalizedString(key: "about.paragraph1") public static var about_paragraph1: Text
    /// Event name...
    @LocalizedString(key: "textfield.event.name.placeholder") public static var textfield_event_name_placeholder: Text
    /// Select an Event
    @LocalizedString(key: "common.select.an.event") public static var common_select_an_event: Text
    /// Due Date
    @LocalizedString(key: "datepicker.due.date") public static var datepicker_due_date: Text
    /// Photo Library
    @LocalizedString(key: "imagepicker.photo.library") public static var imagepicker_photo_library: Text
    /// Following
    @LocalizedString(key: "contributors.following") public static var contributors_following: Text
    /// Start Date
    @LocalizedString(key: "datepicker.start.date") public static var datepicker_start_date: Text
    /// Retry
    @LocalizedString(key: "button.retry") public static var button_retry: Text
    /// Profile
    @LocalizedString(key: "profile.title") public static var profile_title: Text
    /// About
    @LocalizedString(key: "settings.about") public static var settings_about: Text
    /// Clear
    @LocalizedString(key: "button.clear") public static var button_clear: Text
    /// Find the best place for your event...
    @LocalizedString(key: "search.place.placeholder") public static var search_place_placeholder: Text
    /// Select a category
    @LocalizedString(key: "textfield.select.category") public static var textfield_select_category: Text
    /// What's on your mind?
    @LocalizedString(key: "feed.whats.on.your.mind") public static var feed_whats_on_your_mind: Text
    /// Settings
    @LocalizedString(key: "settings.title") public static var settings_title: Text
    /// Next
    @LocalizedString(key: "button.next") public static var button_next: Text
    /// Buddies Community, being a platform dedicated to iOS development, aims to provide a productive environment fostering networking, collaboration, and knowledge sharing.
    @LocalizedString(key: "onboardingItem.FirstDescription") public static var onboardingitem_firstdescription: Text
    /// Oops 🧐
    @LocalizedString(key: "alert.error.title") public static var alert_error_title: Text
    /// Clear Filters
    @LocalizedString(key: "contributors.clear.filters") public static var contributors_clear_filters: Text
    /// Filter
    @LocalizedString(key: "contributors.filter") public static var contributors_filter: Text
    /// %d contributions
    @LocalizedString(key: "contributors.contributions.count") public static var contributors_contributions_count: Text
    /// Between
    @LocalizedString(key: "event.details.between") public static var event_details_between: Text
    /// Try Again
    @LocalizedString(key: "button.try.again") public static var button_try_again: Text
    /// Sign in with Google
    @LocalizedString(key: "button.sign.in.with.google") public static var button_sign_in_with_google: Text
    /// Recent Activities
    @LocalizedString(key: "contributors.recent.activities") public static var contributors_recent_activities: Text
    /// About your event...
    @LocalizedString(key: "textfield.event.description.placeholder") public static var textfield_event_description_placeholder: Text
    /// Category option cannot be empty.
    @LocalizedString(key: "alert.error.category.empty") public static var alert_error_category_empty: Text
    /// Liked
    @LocalizedString(key: "profile.tab.liked") public static var profile_tab_liked: Text
    /// Filter by Category
    @LocalizedString(key: "filter.by.category") public static var filter_by_category: Text
    /// BuddiesIOS
    @LocalizedString(key: "onboardingItem.SecondTitle") public static var onboardingitem_secondtitle: Text
    /// Please specify the event location.
    @LocalizedString(key: "alert.error.location.empty") public static var alert_error_location_empty: Text
    /// Feed
    @LocalizedString(key: "tab.feed") public static var tab_feed: Text
    /// Next
    @LocalizedString(key: "onboarding.ButtonTitle") public static var onboarding_buttontitle: Text
    /// Create
    @LocalizedString(key: "button.create") public static var button_create: Text
    /// Feed
    @LocalizedString(key: "feed.title") public static var feed_title: Text
    /// Topluluğumuz hem yeni başlayanlar hem de deneyimli geliştiriciler için açık bir platform. Bizim için öğrenmek ve ortak ilgi alanlarına sahip insanlarla zaman geçirmek çok değerli. Arada mentorluk da yapıyoruz, yani tecrübelerimizi paylaşmak ve birbirimize destek olmak da önceliklerimizden biri.
    @LocalizedString(key: "about.paragraph.3") public static var about_paragraph_3: Text
    /// Info!
    @LocalizedString(key: "alert.info.title") public static var alert_info_title: Text
    /// Tap info button to see details
    @LocalizedString(key: "map.event.info.hint") public static var map_event_info_hint: Text
    /// Username
    @LocalizedString(key: "profile.field.username") public static var profile_field_username: Text
    /// Dive in, explore, learn and share. We're excited to have you here and can't wait to see what you'll bring to the table.
    @LocalizedString(key: "onboardingItem.SecondDescription") public static var onboardingitem_seconddescription: Text
    /// Buluşmalarımızı genellikle yüz yüze gerçekleştiriyoruz, ama gelecekte çevrimiçi etkinlikler de planlıyoruz. Amacımız, karşılıklı olarak pek sık karşılaşma şansımız olmayan insanları tek bir çatı altında toplamak ve ortak bir bilinç oluşturmak. Birlikte yazdığımız kodları tartışmak, çalıştığımız ortamları nasıl daha iyi hale getirebileceğimizi, şirket baskısı olmadan rahatça fikir alışverişi yapmayı ve tabii ki birbirimizi tanımak istiyoruz.
    @LocalizedString(key: "about.paragraph.2") public static var about_paragraph_2: Text
    /// Followers
    @LocalizedString(key: "contributors.followers") public static var contributors_followers: Text
    /// Event Details
    @LocalizedString(key: "event.details") public static var event_details: Text
    /// Error loading contributors
    @LocalizedString(key: "contributors.error.loading") public static var contributors_error_loading: Text
    /// Choose Image Source
    @LocalizedString(key: "imagepicker.choose.source") public static var imagepicker_choose_source: Text
    /// User Information
    @LocalizedString(key: "profile.section.user.info") public static var profile_section_user_info: Text
    /// Cancel
    @LocalizedString(key: "button.cancel") public static var button_cancel: Text
    /// Camera
    @LocalizedString(key: "imagepicker.camera") public static var imagepicker_camera: Text
    /// Save
    @LocalizedString(key: "button.save") public static var button_save: Text
    /// GitHub URL
    @LocalizedString(key: "textfield.github.url") public static var textfield_github_url: Text
    /// Share
    @LocalizedString(key: "button.share") public static var button_share: Text
    /// No recent activities
    @LocalizedString(key: "common.no.recent.activities") public static var common_no_recent_activities: Text
    /// SwiftBuddies'e hoş geldin! Burada kendini rahat hissedebileceğin bir ortamda buluşmayı umuyoruz.
    @LocalizedString(key: "about.welcome") public static var about_welcome: Text
    /// Loading...
    @LocalizedString(key: "common.loading") public static var common_loading: Text
    /// GitHub Contributors
    @LocalizedString(key: "contributors.github.title") public static var contributors_github_title: Text
    /// Content
    @LocalizedString(key: "profile.tabs.title") public static var profile_tabs_title: Text
    /// New Post
    @LocalizedString(key: "feed.new.post") public static var feed_new_post: Text
    /// SwiftBuddies, mobil ve yazılım geliştirmeye meraklı insanların bir araya geldiği sıcak bir topluluk. Özellikle iOS geliştirme konusunda yoğunlaşıyoruz. İletişimimizi genellikle Türkçe yapıyoruz, ancak İngilizce bilmeyen arkadaşlarımız da varsa onlarla İngilizce olarak da iletişim kuruyoruz.
    @LocalizedString(key: "about.paragraph.1") public static var about_paragraph_1: Text
    /// Buttons Showcase
    @LocalizedString(key: "settings.buttons.showcase") public static var settings_buttons_showcase: Text
    /// Map
    @LocalizedString(key: "tab.map") public static var tab_map: Text
    /// Open in GitHub
    @LocalizedString(key: "contributors.open.in.github") public static var contributors_open_in_github: Text
    /// Topluluğumuz hem yeni başlayanlar hem de deneyimli geliştiriciler için açık bir platform. Bizim için öğrenmek ve ortak ilgi alanlarına sahip insanlarla zaman geçirmek çok değerli. Arada mentorluk da yapıyoruz, yani tecrübelerimizi paylaşmak ve birbirimize destek olmak da önceliklerimizden biri.
    @LocalizedString(key: "about.paragraph3") public static var about_paragraph3: Text
}
