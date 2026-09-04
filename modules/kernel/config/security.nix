{ kernel, lib, ... }: {
  kernel.config.security = with lib.kernel; {
    apply =
      with kernel.config.security;
      lib.mkMerge [
        (include { })
        denied
      ];

    include = { }: {
      LEGACY_VSYSCALL_NONE = yes;
      MAGIC_SYSRQ_DEFAULT_ENABLE = freeform "0x84";
      RESET_ATTACK_MITIGATION = yes;
      SECURITY_LOCKDOWN_LSM = lib.mkForce yes;
      TCG_TPM = yes;
    };

    denied = lib.mkMerge [
      {
        CRYPTO_842 = no;
        CRYPTO_ADIANTUM = no;
        CRYPTO_AEGIS128 = no;
        CRYPTO_AEGIS128_AESNI_SSE2 = no;
        #CRYPTO_ARIA = no;
        #CRYPTO_ARIA_AESNI_AVX2_X86_64 = no;
        #CRYPTO_ARIA_AESNI_AVX_X86_64 = no;
        CRYPTO_ARIA_GFNI_AVX512_X86_64 = no;
        CRYPTO_BENCHMARK = no;
        CRYPTO_BLOWFISH_X86_64 = no;
        CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 = no;
        #CRYPTO_CAMELLIA_AESNI_AVX_X86_64 = no;
        #CRYPTO_CAMELLIA_X86_64 = no;
        #CRYPTO_CAST5 = no;
        CRYPTO_CAST5_AVX_X86_64 = no;
        # CRYPTO_CAST6 = no;
        CRYPTO_CAST6_AVX_X86_64 = no;
        CRYPTO_CRC32 = no;
        CRYPTO_DEV_AMLOGIC_GXL = no;
        CRYPTO_DEV_ATMEL_ECC = no;
        CRYPTO_DEV_ATMEL_SHA204A = no;
        CRYPTO_DEV_NITROX_CNN55XX = no;
        CRYPTO_DEV_PADLOCK = no;
        CRYPTO_DEV_QAT_420XX = no;
        CRYPTO_DEV_QAT_4XXX = no;
        CRYPTO_DEV_QAT_6XXX = no;
        CRYPTO_DEV_QAT_C3XXX = no;
        CRYPTO_DEV_QAT_C3XXXVF = no;
        CRYPTO_DEV_QAT_C62X = no;
        CRYPTO_DEV_QAT_C62XVF = no;
        CRYPTO_DEV_QAT_DH895xCC = no;
        CRYPTO_DEV_QAT_DH895xCCVF = no;
        CRYPTO_DEV_SAFEXCEL = no;
        CRYPTO_DEV_VIRTIO = no;
        CRYPTO_ECRDSA = no;
        CRYPTO_FCRYPT = no;
        CRYPTO_HCTR2 = no;
        CRYPTO_MD4 = no;
        CRYPTO_NULL = no;
        CRYPTO_PCBC = no;
        CRYPTO_PCRYPT = no;
        CRYPTO_RMD160 = no;
        #CRYPTO_SERPENT = no;
        CRYPTO_SERPENT_AVX2_X86_64 = no;
        #CRYPTO_SERPENT_AVX_X86_64 = no;
        CRYPTO_SERPENT_SSE2_X86_64 = no;
        CRYPTO_SM4_AESNI_AVX2_X86_64 = no;
        #CRYPTO_SM4_AESNI_AVX_X86_64 = no;
        CRYPTO_STREEBOG = no;
        CRYPTO_TWOFISH_AVX_X86_64 = no;
        #CRYPTO_TWOFISH_X86_64 = no;
        #CRYPTO_TWOFISH_X86_64_3WAY = no;
        CRYPTO_USER_API_ENABLE_OBSOLETE = no;
        CRYPTO_USER_API_RNG = no;
        CRYPTO_WP512 = no;
        CRYPTO_XCBC = no;
      }
      {
        FIPS_SIGNATURE_SELFTEST = no;
        PKCS7_TEST_KEY = no;
        PKCS8_PRIVATE_KEY_PARSER = no;
        SECURITY_IPE = no;
        SECURITY_LOADPIN = no;
        SECURITY_SELINUX = no;
        SECURITY_SMACK = no;
        SECURITY_TOMOYO = no;
        TCG_ATMEL = no;
        TCG_INFINEON = no;
        TCG_NSC = no;
        TCG_TIS_I2C = no;
        TCG_TIS_I2C_ATMEL = no;
        TCG_TIS_I2C_CR50 = no;
        TCG_TIS_I2C_INFINEON = no;
        TCG_TIS_I2C_NUVOTON = no;
      }
    ];
  };
}
