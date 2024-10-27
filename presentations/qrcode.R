library(qrcode)

png(file="qr.png")
qr <- qr_code("https://textvulture.github.io/presentations/GuestLecture_10292024.html")
plot(qr)
dev.off()

png(file="qr2.png")
qr2 <- qr_code("https://textvulture.github.io/presentations/bkv_slide.html")
plot(qr2)
dev.off()