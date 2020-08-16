using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL
{
    public class KomentariBL : IKomentariBL
    {
        private readonly IKomentariDAL _IKomentariDAL;
        private readonly List<Komentari> komentari;
        private readonly IKorisnikBL _IKorisnikBL;

        public KomentariBL(IKomentariDAL IKomentariDAL, IKorisnikBL IKorisnikBL)
        {
            _IKomentariDAL = IKomentariDAL;
             komentari = _IKomentariDAL.getAllKomentari();
            _IKorisnikBL = IKorisnikBL;
        }

        public List<Komentari> dajSveKomentareByIdObjave(long idObjave)
        {
            List<SveZaKomentare> komentariSaKorisnicima = new List<SveZaKomentare>();
             var listaKomentara = komentari.Where(k => k.ObjaveID == idObjave);
            return listaKomentara.ToList();
        }
        public List<Komentari> getKomentareByKorisnikId(long idKorisnika)
        {
            return komentari.Where(k => k.KorisnikID == idKorisnika).ToList();
        }

        public List<Komentari> getAllKomentari()
        {
            return _IKomentariDAL.getAllKomentari();
        }

        public long getBrojKomentaraByIdObjave(long idObjave)
        {
            var pokupiKomentare = komentari.Where(k => k.ObjaveID == idObjave);
            long brojKomentara = pokupiKomentare.Count();
            return brojKomentara;
        }

        public void saveKomentar(PrihvatanjeKomentara data, int poslataSlika,int resenProblem)
        {
             _IKomentariDAL.saveKomentar(data,poslataSlika,resenProblem);
        }

        public void saveImage(PrihvatanjeSlikeKomentara image)
        {
            _IKomentariDAL.saveImage(image);
        }

        public void deleteKomentareByIdObjave(long idObjave)
        {
            List<Komentari> listaKomentara = getKomentareByIdObjave(idObjave);
             _IKomentariDAL.deleteKomentare(listaKomentara);   
        }

        public void deleteKomentareByIdKorisnika(long idKorisnika)
        {
            List<Komentari> listaKomentara = getKomentareByKorisnikId(idKorisnika);
             _IKomentariDAL.deleteKomentare(listaKomentara);
        }

        public List<Komentari> getKomentareByIdObjave(long idObjave)
        {
            return komentari.Where(k => k.ObjaveID == idObjave).ToList();
        }

        public void deleteKomentarByIdKomentara(long idKomentara,int ind)
        {
            Komentari komentar = getKomentarByIdKomentara(idKomentara);
            _IKomentariDAL.deleteKomentar(komentar,ind);
        }

        public Komentari getKomentarByIdKomentara(long idKomentara)
        {
            return komentari.SingleOrDefault(k => k.id == idKomentara);
        }

        public List<Komentari> getAllReseneProbleme()
        {
            return _IKomentariDAL.getAllReseneProbleme();
        }

        public List<Komentari> getReseneProblemeByIdObjave(long idObjave)
        {
            return  komentari.Where(k => k.resenProblem == 1 && k.ObjaveID == idObjave).ToList();
          
        }

        public Komentari problemResen(long idKomentara)
        {
            var komentar = getKomentarByIdKomentara(idKomentara);
            if (komentar != null )
            return _IKomentariDAL.problemResen(komentar);
            return null;
        }

        public List<Komentari> getOznaceneKaoReseniProblemiByIdObjave(long idObjave)
        {
            return komentari.Where(k => k.oznacenKaoResen == 1 && k.ObjaveID == idObjave).ToList();
        }

        public int saveResenjeInstitucije(PrihvatanjeResenihProbelma slika)
        {
            return _IKomentariDAL.saveResenjeInstitucije(slika);
        }

        public Komentari izmenaKomentara(Komentari izmena)
        {
            return _IKomentariDAL.izmenaKomentara(izmena);
        }
    }
}
