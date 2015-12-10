//
// Avoid duplicate symbols caused by import of certificate in two different classes. Ignore this.
//

#ifndef VO_CERTIFICATE_TYPE
#define VO_CERTIFICATE_TYPE

/**
 * Holds a certificate.
 */
typedef struct _voCertificate
{
    /**
     * Pointer to the bytes composing the certificate.
     */
    const char* bytes;
    
    /**
     * Length of the certificate.
     */
    size_t length;
}
voCertificate;

#endif // end of: #ifndef VO_CERTIFICATE_TYPE

extern voCertificate const myCertificate;
