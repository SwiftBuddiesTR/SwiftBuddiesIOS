import SwiftUI
import Design

struct AboutView: View {
    var body: some View {
        HeaderParallaxView {
            VStack {
                Image("SwiftBuddiesHeader", bundle: DesignResources.bundle)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        } content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("Merhaba SwiftBuddies!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("SwiftBuddies, mobil ve yazılım geliştirmeye meraklı insanların bir araya geldiği sıcak bir topluluk. Özellikle iOS geliştirme konusunda yoğunlaşıyoruz. İletişimimizi genellikle Türkçe yapıyoruz, ancak İngilizce bilmeyen arkadaşlarımız da varsa onlarla İngilizce olarak da iletişim kuruyoruz.")
                    .foregroundColor(.primary)
                
                Text("Buluşmalarımızı genellikle yüz yüze gerçekleştiriyoruz, ama gelecekte çevrimiçi etkinlikler de planlıyoruz. Amacımız, karşılıklı olarak pek sık karşılaşma şansımız olmayan insanları tek bir çatı altında toplamak ve ortak bir bilinç oluşturmak. Birlikte yazdığımız kodları tartışmak, çalıştığımız ortamları nasıl daha iyi hale getirebileceğimizi, şirket baskısı olmadan rahatça fikir alışverişi yapmayı ve tabii ki birbirimizi tanımak istiyoruz.")
                    .foregroundColor(.primary)
                
                Text("Topluluğumuz hem yeni başlayanlar hem de deneyimli geliştiriciler için açık bir platform. Bizim için öğrenmek ve ortak ilgi alanlarına sahip insanlarla zaman geçirmek çok değerli. Arada mentorluk da yapıyoruz, yani tecrübelerimizi paylaşmak ve birbirimize destek olmak da önceliklerimizden biri.")
                    .foregroundColor(.primary)
                
                Text("SwiftBuddies'e hoş geldin! Burada kendini rahat hissedebileceğin bir ortamda buluşmayı umuyoruz.")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

#Preview {
    AboutView()
}
