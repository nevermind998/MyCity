using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class SveObjave : IEquatable<SveObjave>
    {
        public long idObjave { get; set; }
        public TekstualneObjave tekstualna_objava { get; set; }
        public Slike slika { get; set; }
        public KorisnikSaGradovima vlasnikObjave { get; set; }
        public long brojLajkova { get; set; }
        public int aktivanKorisnikLajkovao { get; set; } //1 -> yes
        public int aktivanKorisnikDislajkovao { get; set; }
        public int aktivanKorisnikReport { get; set; }
        public long resenaObjava { get; set; }
        public long brojDislajkova { get; set; }
        public long brojReporta { get; set; }
        public long brojKomentara { get; set; }
       // public List<SveZaKomentare> komentari { get; set; }
        public DateTime vreme { get; set; }
        public String vreme2 { get; set; }
        public LepeStvari lepaStvar { get; set; }
        public List<KategorijeProblema> kategorije { get; set; }

        public bool Equals(SveObjave other)
        {
            if (other is null)
                return false;

            return this.idObjave == other.idObjave;
        }
        // public String satImin { get; set; }
        public override bool Equals(object obj) => Equals(obj as SveObjave);
        public override int GetHashCode() => (idObjave).GetHashCode();

    }
}
