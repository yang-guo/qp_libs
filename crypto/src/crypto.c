#include <stdlib.h>
#include <openssl/sha.h>
#include <openssl/evp.h>
#include <openssl/hmac.h>
#include <openssl/bio.h>
#include <openssl/buffer.h>
#include "k.h"

//*******************************************
//HMACS
//*******************************************
K hmac_sha1(K x,K y){
	unsigned char* digest;
	digest=HMAC(EVP_sha1(),kC(y),y->n,kC(x),x->n,NULL,NULL);
	K signature=kpn(digest, SHA_DIGEST_LENGTH);
	R signature;
}

K hmac_sha256(K x,K y){
	unsigned char* digest;
	digest = HMAC(EVP_sha256(), kC(y), y->n, kC(x), x->n, NULL, NULL);
	K signature = kpn(digest, SHA256_DIGEST_LENGTH);
	return signature;
}

K hmac_sha384(K x,K y){
	unsigned char* digest;
	digest = HMAC(EVP_sha384(), kC(y), y->n, kC(x), x->n, NULL, NULL);
	K signature = kpn(digest, SHA384_DIGEST_LENGTH);
	return signature;
}

K hmac_sha512(K x,K y){
	unsigned char* digest;
	digest = HMAC(EVP_sha512(), kC(y), y->n, kC(x), x->n, NULL, NULL);
	K signature = kpn(digest, SHA512_DIGEST_LENGTH);
	return signature;
}

K convert_base16(K x){
	unsigned char* digest = kC(x);
	char* base16 = malloc(sizeof(char) * 2 * x->n);
	int i;
	for (i = 0;i < x->n;++i) 
		sprintf(&base16[i * 2], "%02x", digest[i]);
	K ret = kpn(base16, 2 * x->n);
	return ret;
}

K convert_base64(K x){
	BIO *bmem, *b64;
	BUF_MEM *bptr;

	b64 = BIO_new(BIO_f_base64());
	bmem = BIO_new(BIO_s_mem());
	BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
	b64 = BIO_push(b64, bmem);
	BIO_write(b64, kC(x),x->n);
	BIO_flush(b64);
	BIO_get_mem_ptr(b64, &bptr);

	K ret = kpn((char*)bptr->data, bptr->length);
	BIO_free_all(b64);
	return ret;
}