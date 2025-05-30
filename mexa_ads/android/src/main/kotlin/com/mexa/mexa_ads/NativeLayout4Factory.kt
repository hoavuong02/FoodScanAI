package com.mexa.mexa_ads

import android.annotation.SuppressLint
import android.content.res.Resources
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.graphics.drawable.DrawableCompat
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeLayout4Factory : GoogleMobileAdsPlugin.NativeAdFactory {
    private var layoutInflater: LayoutInflater

    constructor(layoutInflater: LayoutInflater) {
        this.layoutInflater = layoutInflater
    }

    @SuppressLint("UseCompatLoadingForDrawables")
    override fun createNativeAd(
        nativeAd: NativeAd?,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {

        val adView = layoutInflater.inflate(R.layout.native_layout_4, null) as NativeAdView

//         Set the media view.
        adView.mediaView = adView.findViewById(R.id.ad_media)

        // Set other ad assets.
        val mainAdView: ConstraintLayout = adView.findViewById(R.id.main_ad_view)
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_icon)
//    adView.priceView = adView.findViewById(R.id.ad_price)
//        adView.starRatingView = adView.findViewById(R.id.rating_bar)
//    adView.storeView = adView.findViewById(R.id.ad_store)
//    adView.advertiserView = adView.findViewById(R.id.ad_advertiser)

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.headlineView as TextView).text = nativeAd?.headline
        adView.mediaView?.mediaContent = nativeAd?.mediaContent

        // These assets aren't guaranteed to be in every NativeAd, so it's important to
        // check before trying to display them.
        if (nativeAd?.body == null) {
            adView.bodyView?.visibility = View.INVISIBLE
        } else {
            adView.bodyView?.visibility = View.VISIBLE
            (adView.bodyView as TextView).text = nativeAd.body
        }

        if (nativeAd?.callToAction == null) {
            adView.callToActionView?.visibility = View.INVISIBLE
        } else {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as Button).text = nativeAd.callToAction
        }

        if (nativeAd?.icon == null) {
            adView.iconView?.visibility = View.GONE
        } else {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
            adView.iconView?.visibility = View.VISIBLE
        }

//        if (nativeAd?.price == null) {
//            adView.priceView?.visibility = View.INVISIBLE
//        } else {
//            adView.priceView?.visibility = View.VISIBLE
////      (adView.priceView as TextView).text = nativeAd.price
//        }
//
//        if (nativeAd?.store == null) {
//            adView.storeView?.visibility = View.INVISIBLE
//        } else {
//            adView.storeView?.visibility = View.VISIBLE
////      (adView.storeView as TextView).text = nativeAd.store
//        }

//        if (nativeAd?.starRating == null) {
//            adView.starRatingView?.visibility = View.INVISIBLE
//        } else {
//            (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
////      adView.starRatingView?.visibility = View.VISIBLE
//        }

//        if (nativeAd?.advertiser == null) {
//            adView.advertiserView?.visibility = View.INVISIBLE
//        } else {
//            adView.advertiserView?.visibility = View.VISIBLE
////      (adView.advertiserView as TextView).text = nativeAd.advertiser
//        }

        if (customOptions != null) {
            if (customOptions["ad_height"] != null) {
                mainAdView.layoutParams.height =
                    ((customOptions["ad_height"] as Int) * Resources.getSystem().displayMetrics.density).toInt()
            }
            if (customOptions["bg_color"] != null) {
                val wrappedDrawable = DrawableCompat.wrap(
                    MexaAdsPlugin.resources
                        .getDrawable(R.drawable.bg_border_radius_12, null)
                )
                DrawableCompat.setTint(wrappedDrawable, Color.parseColor(customOptions["bg_color"] as String))

                mainAdView.background = wrappedDrawable
            }
            if (customOptions["cta_bg_color"] != null) {
                val colors = customOptions["cta_bg_color"] as List<String>

                if (colors.size >= 2) {
                    // Nếu có từ 2 màu trở lên, tạo gradient drawable
                    val intColors = colors.map { Color.parseColor(it) }.toIntArray()

                    // Kiểm tra hướng gradient (nếu không có thì mặc định LEFT_RIGHT)
                    val gradientOrientation = when (customOptions["gradient_orientation"] as? String) {
                        "LEFT_RIGHT" -> GradientDrawable.Orientation.LEFT_RIGHT
                        "TOP_BOTTOM" -> GradientDrawable.Orientation.TOP_BOTTOM
                        "RIGHT_LEFT" -> GradientDrawable.Orientation.RIGHT_LEFT
                        "BOTTOM_TOP" -> GradientDrawable.Orientation.BOTTOM_TOP
                        "BL_TR" -> GradientDrawable.Orientation.BL_TR
                        "BR_TL" -> GradientDrawable.Orientation.BR_TL
                        "TL_BR" -> GradientDrawable.Orientation.TL_BR
                        "TR_BL" -> GradientDrawable.Orientation.TR_BL
                        else -> GradientDrawable.Orientation.LEFT_RIGHT // Mặc định
                    }

                    // Tạo GradientDrawable
                    val gradientDrawable = GradientDrawable(gradientOrientation, intColors)
                    gradientDrawable.cornerRadius = 8 * Resources.getSystem().displayMetrics.density // Bo góc

                    // Gán gradient drawable cho background của nút
                    (adView.callToActionView as Button).background = gradientDrawable
                } else if (colors.size == 1) {
                    // Nếu chỉ có 1 màu, sử dụng mã của bạn
                    val borderRadius = customOptions["cta_border_radius"]

                    val drawableResource = when (borderRadius) {
                        12 -> R.drawable.bg_border_radius_12
                        16 -> R.drawable.bg_border_radius_16
                        20 -> R.drawable.bg_border_radius_20
                        24 -> R.drawable.bg_border_radius_24
                        28 -> R.drawable.bg_border_radius_28
                        30 -> R.drawable.bg_border_radius_30
                        else -> R.drawable.bg_border_radius_12 // Giá trị mặc định
                    }
                    val wrappedDrawable = DrawableCompat.wrap(
                        MexaAdsPlugin.resources.getDrawable(drawableResource, null)
                    )
                    DrawableCompat.setTint(wrappedDrawable, Color.parseColor(colors[0])) // Áp dụng màu HEX vào drawable

                    // Gán màu cho background của nút
                    (adView.callToActionView as Button).background = wrappedDrawable
                } else {
                    // Nếu không có màu nào, set màu mặc định
                    val defaultColor = Color.parseColor("#FF6200EE") // Màu mặc định (ví dụ: màu tím)
                    val borderRadius = customOptions["cta_border_radius"]

                    val drawableResource = when (borderRadius) {
                        12 -> R.drawable.bg_border_radius_12
                        16 -> R.drawable.bg_border_radius_16
                        20 -> R.drawable.bg_border_radius_20
                        24 -> R.drawable.bg_border_radius_24
                        28 -> R.drawable.bg_border_radius_28
                        30 -> R.drawable.bg_border_radius_30
                        else -> R.drawable.bg_border_radius_12 // Giá trị mặc định
                    }
                    val wrappedDrawable = DrawableCompat.wrap(
                        MexaAdsPlugin.resources.getDrawable(drawableResource, null)
                    )
                    DrawableCompat.setTint(wrappedDrawable, defaultColor) // Áp dụng màu mặc định vào drawable

                    // Gán màu mặc định cho background của nút
                    (adView.callToActionView as Button).background = wrappedDrawable
                }
            }
            if (customOptions["title_text_color"] != null) {
                (adView.headlineView as TextView).setTextColor(
                    Color.parseColor(customOptions["title_text_color"] as String)
                )
            }
            if (customOptions["body_text_color"] != null) {
                (adView.bodyView as TextView).setTextColor(
                    Color.parseColor(customOptions["body_text_color"] as String)
                )
            }
            if (customOptions["cta_text_color"] != null) {
                (adView.callToActionView as TextView).setTextColor(
                    Color.parseColor(customOptions["cta_text_color"] as String)
                )
            }
            if (customOptions["ad_banner_color"] != null) {
                val wrappedDrawable = DrawableCompat.wrap(
                    MexaAdsPlugin.resources
                        .getDrawable(R.drawable.bg_text_ad, null)
                )
                DrawableCompat.setTint(wrappedDrawable, Color.parseColor(customOptions["ad_banner_color"] as String))
                (adView.findViewById(R.id.ad_banner) as TextView).background =
                    wrappedDrawable

            }

        }

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        if (nativeAd != null) {
            adView.setNativeAd(nativeAd)
        }

        return adView
    }
}