using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Slike
    {
        public long id { get; set; }
        public long ObjaveID { get; set; }
        public virtual Objave objave { get; set; }
        public float x { get; set; }
        public float y { get; set; }
        public String opis_slike { get; set; }
        public String urlSlike { get; set; }
    }
}
