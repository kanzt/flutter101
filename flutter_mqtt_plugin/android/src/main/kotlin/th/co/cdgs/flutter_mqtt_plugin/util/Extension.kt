package th.co.cdgs.flutter_mqtt_plugin.util

import android.app.AlertDialog
import android.content.BroadcastReceiver
import android.content.Context
import android.content.DialogInterface
import com.google.gson.Gson
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.EmptyCoroutineContext
import kotlin.coroutines.resume

fun String?.isNullOrBlankOrEmpty(): Boolean =
    this.isNullOrEmpty() || this.isNullOrBlank() || this == "null"


fun Context.buildMessageDialog(title: String? = "", message: String? = ""): AlertDialog {
    val builder = AlertDialog.Builder(this)
    builder.setTitle(title)
    builder.setMessage(message)
//    builder.setPositiveButton(this.resources!!.getString(android.R.string.ok)) { dialog, _ -> dialog.dismiss() }
//    builder.setNegativeButton(this.resources!!.getString(android.R.string.cancel)) { dialog, _ -> dialog.dismiss() }
    builder.setCancelable(false)
    return builder.create()
}

/**
 * https://federicokt.medium.com/smarter-dialogs-with-coroutines-b83e1d0e06a0
 */
suspend fun AlertDialog.await(
    context: Context,
    positiveText: String? = null,
    negativeText: String? = null
) = suspendCancellableCoroutine<Boolean> { cont ->
    val defaultPositiveText = positiveText ?: context.resources.getString(android.R.string.ok)
    val defaultNegativeText = negativeText ?: context.resources.getString(android.R.string.cancel)
    val listener = DialogInterface.OnClickListener { _, which ->
        if (which == AlertDialog.BUTTON_POSITIVE) cont.resume(true)
        else if (which == AlertDialog.BUTTON_NEGATIVE) cont.resume(false)
    }

    setButton(AlertDialog.BUTTON_POSITIVE, defaultPositiveText, listener)
    // setButton(AlertDialog.BUTTON_NEGATIVE, defaultNegativeText, listener)

    // we can either decide to cancel the coroutine if the dialog
    // itself gets cancelled, or resume the coroutine with the
    // value [false]
    setOnCancelListener { cont.cancel() }

    // if we make this coroutine cancellable, we should also close the
    // dialog when the coroutine is cancelled
    cont.invokeOnCancellation { dismiss() }

    // remember to show the dialog before returning from the block,
    // you won't be able to do it after this function is called!
    show()
}

open class Data

fun <T> Data.deepCopy(): T? = Gson().run {
    fromJson(toJson(this@deepCopy), this@deepCopy.javaClass) as? T
}

/**
 * BoardcastReceiver
 */
fun BroadcastReceiver.goAsync(
    context: CoroutineContext = EmptyCoroutineContext,
    block: suspend CoroutineScope.() -> Unit
) {
    val pendingResult = goAsync()
    CoroutineScope(SupervisorJob()).launch(context) {
        try {
            block()
        } finally {
            pendingResult.finish()
        }
    }
}