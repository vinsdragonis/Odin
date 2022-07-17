void KMain(void)
{
    char* p = (char*)0xb8000;

    p[0] = 'C';
    p[1] = 0x9;
}