using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class OcenaAplikacije
    {
        public float prosecnaOcena { get; set; }
        public long glasalo { get; set; }
        public long nijeGlasalo { get; set; }
        public long brojKorisnika { get; set; }
    }
}
