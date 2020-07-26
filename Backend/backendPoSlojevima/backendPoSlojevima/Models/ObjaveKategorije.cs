using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class ObjaveKategorije
    {
        public long id { get; set; }
        public long ObjaveID { get; set; }
        public virtual Objave objava { get; set; }
        public long KategorijaID { get; set; }
        public virtual KategorijeProblema kategorija { get; set; }
    }
}
