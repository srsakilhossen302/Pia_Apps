# Stripe ProGuard Rules
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.pushProvisioning.** { *; }

# General Stripe rules
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**
