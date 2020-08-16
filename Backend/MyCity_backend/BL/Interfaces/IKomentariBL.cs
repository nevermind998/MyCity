using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IKomentariBL
    {
        List<Komentari> getAllKomentari();
        public void saveKomentar(PrihvatanjeKomentara data,int poslataSlika,int resenProblem);
        public void deleteKomentareByIdObjave(long idObjave);
        public void deleteKomentareByIdKorisnika(long idKorisnika);
        List<Komentari> getKomentareByIdObjave(long idObjave);
        long getBrojKomentaraByIdObjave(long data);
        public List<Komentari> dajSveKomentareByIdObjave(long data);
        List<Komentari> getKomentareByKorisnikId(long data);
        void saveImage(PrihvatanjeSlikeKomentara image);
        void deleteKomentarByIdKomentara(long idKomentara,int ind);
        Komentari getKomentarByIdKomentara(long idKomentara);
        public List<Komentari> getAllReseneProbleme();

        public List<Komentari> getReseneProblemeByIdObjave(long idObjave);
        public Komentari problemResen(long idKomentar);

        List<Komentari> getOznaceneKaoReseniProblemiByIdObjave(long idObjave);
        public int saveResenjeInstitucije(PrihvatanjeResenihProbelma slika);
        public Komentari izmenaKomentara(Komentari izmena);

    }
}
