using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IKomentariDAL
    {
        List<Komentari> getAllKomentari();
        void saveKomentar(PrihvatanjeKomentara data, int poslataSlika,int resenProblem);
        void saveImage(PrihvatanjeSlikeKomentara image);
        void deleteKomentare(List<Komentari> komentari);
        void deleteKomentar(Komentari komentar,int ind);
        public List<Komentari> getAllReseneProbleme();
        public Komentari problemResen(Komentari komentar);
        public int saveResenjeInstitucije(PrihvatanjeResenihProbelma slika);
        public Komentari izmenaKomentara(Komentari izmena);
        




    }
}
