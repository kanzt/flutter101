package com.example.mqttkotlinsample.data.entity

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize


@Parcelize
data class NotificationPayload(
    @SerializedName("to")
    val to: String,
    @SerializedName("data")
    val data: NotificationContent,
) : Parcelable

@Parcelize
data class NotificationContent(
    @SerializedName("id")
    val id: Long,
    @SerializedName("title")
    val title: String,
    @SerializedName("subtitle")
    val subtitle: String,
    @SerializedName("body")
    val body: String,
    @SerializedName("customProperties")
    val customProperties: List<Property>,
) : Parcelable

@Parcelize
data class Property(
    @SerializedName("key")
    val key: String,
    @SerializedName("value")
    val value: String,
) : Parcelable