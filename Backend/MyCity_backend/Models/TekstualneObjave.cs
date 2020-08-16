using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class TekstualneObjave
    {
        public long id { get; set; }
        public long ObjaveID { get; set; }
        public virtual Objave objave { get; set; }
        public String tekst { get; set; }
    }
}
