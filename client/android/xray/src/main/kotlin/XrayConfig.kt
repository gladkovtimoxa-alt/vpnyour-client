package ru.vpnyour.app.protocol.xray

import ru.vpnyour.app.protocol.ProtocolConfig
import ru.vpnyour.app.util.net.InetNetwork

// 1280 (IPv6 minimum) keeps every TCP segment small enough to survive paths with a
// reduced MTU (carrier tunneling / PPPoE) where PMTU discovery is filtered. At 1500 the
// large packets - TLS ServerHello, video, page bodies - silently blackhole through the
// tunnel while small packets (SYN/DNS) pass, so sites "connect" but never load.
private const val XRAY_DEFAULT_MTU = 1280
private const val XRAY_DEFAULT_MAX_MEMORY: Long = 50 shl 20 // 50 MB

class XrayConfig protected constructor(
    protocolConfigBuilder: ProtocolConfig.Builder,
    val socksPort: Int,
    val socksUser: String,
    val socksPass: String,
    val maxMemory: Long,
) : ProtocolConfig(protocolConfigBuilder) {

    protected constructor(builder: Builder) : this(
        builder,
        builder.socksPort,
        builder.socksUser,
        builder.socksPass,
        builder.maxMemory
    )

    class Builder : ProtocolConfig.Builder(false) {
        internal var socksPort: Int = 0
            private set

        internal var socksUser: String = ""
            private set

        internal var socksPass: String = ""
            private set

        internal var maxMemory: Long = XRAY_DEFAULT_MAX_MEMORY
            private set

        override var mtu: Int = XRAY_DEFAULT_MTU

        fun setSocksPort(port: Int) = apply { socksPort = port }

        fun setSocksUser(user: String) = apply { socksUser = user }

        fun setSocksPass(pass: String) = apply { socksPass = pass }

        fun setMaxMemory(maxMemory: Long) = apply { this.maxMemory = maxMemory }

        override fun build(): XrayConfig = configBuild().run { XrayConfig(this@Builder) }
    }

    companion object {
        internal val DEFAULT_IPV4_ADDRESS: InetNetwork = InetNetwork("10.0.42.2", 30)

        inline fun build(block: Builder.() -> Unit): XrayConfig = Builder().apply(block).build()
    }
}
