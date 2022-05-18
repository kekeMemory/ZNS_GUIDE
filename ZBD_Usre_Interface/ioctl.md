```
int zbd_zone_blkreport(struct file_descriptor *fd){
        printf("Start to RUN BLKREPORTZONE\n");
        unsigned long long start_sector = 0;
        struct blk_zone_report *hdr;
        size_t hdr_len;
        int nr_zones=fd->info.nr_zones;


        hdr_len = sizeof(struct blk_zone_report) + nr_zones * sizeof(struct blk_zone);
        hdr = malloc(hdr_len);
        if(!hdr){
            printf("Invalid hdr\n");
            return -1;
        }

        while (1) {
            printf("Go to while\n");
            hdr->sector = start_sector;
            hdr->nr_zones = nr_zones;
            printf ("before ioctl:hdr->nr_zones is : %d \n",hdr->nr_zones);
            int ret = ioctl(fd->read, BLKREPORTZONE,hdr);
            printf("ret is %d\n",ret);
            if (ret){
              break;
            }
            printf ("After ioctl:hdr->nr_zones is : %d \n",hdr->nr_zones);
            if(!hdr->nr_zones){
                printf("There is no zones\n");
                break;
            }

            printf("Got %u zone descriptors\n", hdr->nr_zones);

            /* The next report must start after the last zone reported */
            start_sector = hdr->zones[hdr->nr_zones - 1].start +
               hdr->zones[hdr->nr_zones - 1].len;
}
          printf("Finish to RUN BLKREPORTZONE\n");
          return 0;
}
```
