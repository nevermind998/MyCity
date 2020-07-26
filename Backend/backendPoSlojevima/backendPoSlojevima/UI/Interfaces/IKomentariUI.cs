using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IKomentariUI
    {
        List<Komentari> getAllKomentari();
        public void saveKomentar(PrihvatanjeKomentara data);
        public void deleteKomentareByIdObjave(long idObjave);
        public void deleteKomentareByIdKorisnika(long idKorisnika);
        List<Komentari> getKomentareByIdObjave(long idObjave);
        long getBrojKomentaraByIdObjave(PrihvatanjeIdObjave idObjave);
        public List<Komentari> dajSveKomentareByIdObjave(PrihvatanjeIdObjave data);
        List<Komentari> getKomentareByKorisnikId(PrihvatanjeIdKorisnika data);
        void saveImage(PrihvatanjeSlikeKomentara image);
        List<SveZaKomentare> sveZaKomentare(PrihvatanjeKomentara data);
        void deleteKomentarByIdKomentara(PrihvatanjeIdKomentara data,int ind);
        public List<Komentari> getAllReseneProbleme();
        public List<SveZaReseneProbleme> getReseneProblemeByIdObjave(PrihvatanjeIdObjave idObjave);
        public Komentari problemResen(PrihvatanjeIdKomentara komentara);
        List<SveZaReseneProbleme> getOznacenaReseneProblemeByIdObjave(PrihvatanjeIdObjave objava);
        void problemResenSaViseKomentara(PrihvatanjeNizaKomentara komentari);
        public int saveResenjeInstitucije(PrihvatanjeResenihProbelma slika);
        public Komentari izmenaKomentara(Komentari izmena);
    }
}
