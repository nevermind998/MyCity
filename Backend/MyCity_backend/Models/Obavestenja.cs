using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Obavestenja
    {
        
        public int procitano { get; set; }
        public  long resenje { get; set; }
        public long KomentarID { get; set; }
        public long LajkID { get; set; }
        public KorisnikSaGradovima korisnik { get; set; }
        public  SveObjave objava { get; set; }  //slika objava da kad klikne odvede ga na tu objavu

    }
}
