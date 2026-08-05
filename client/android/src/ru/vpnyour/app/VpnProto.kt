package ru.vpnyour.app

import ru.vpnyour.app.protocol.Protocol
import ru.vpnyour.app.protocol.awg.Awg
import ru.vpnyour.app.protocol.openvpn.OpenVpn
import ru.vpnyour.app.protocol.wireguard.Wireguard
import ru.vpnyour.app.protocol.xray.Xray

enum class VpnProto(
    val label: String,
    val processName: String,
    val serviceClass: Class<out AmneziaVpnService>
) {
    WIREGUARD(
        "VPNYour",
        "ru.vpnyour.app:amneziaAwgService",
        AwgService::class.java
    ) {
        override fun createProtocol(): Protocol = Wireguard()
    },

    AWG(
        "VPNYour",
        "ru.vpnyour.app:amneziaAwgService",
        AwgService::class.java
    ) {
        override fun createProtocol(): Protocol = Awg()
    },

    OPENVPN(
        "OpenVPN",
        "ru.vpnyour.app:amneziaOpenVpnService",
        OpenVpnService::class.java
    ) {
        override fun createProtocol(): Protocol = OpenVpn()
    },

    XRAY(
        "XRay",
        "ru.vpnyour.app:amneziaXrayService",
        XrayService::class.java
    ) {
        override fun createProtocol(): Protocol = Xray.instance
    },

    SSXRAY(
        "SSXRay",
        "ru.vpnyour.app:amneziaXrayService",
        XrayService::class.java
    ) {
        override fun createProtocol(): Protocol = Xray.instance
    };

    private var _protocol: Protocol? = null
    val protocol: Protocol
        get() {
            if (_protocol == null) _protocol = createProtocol()
            return _protocol ?: throw AssertionError("Set to null by another thread")
        }

    protected abstract fun createProtocol(): Protocol

    companion object {
        fun get(protocolName: String): VpnProto = VpnProto.valueOf(protocolName.uppercase())
    }
}
