using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class LajkoviKomentaraUI : ILajkoviKomentaraUI
    {
        private readonly ILajkoviKomentaraBL _ILajkoviKomentaraBL;

        public LajkoviKomentaraUI(ILajkoviKomentaraBL ILajkoviKomentaraBL)
        {
            _ILajkoviKomentaraBL = ILajkoviKomentaraBL;
        }

        public void deleteLajkoveKomentaraByIdKomentara(long idKomentara)
        {
            _ILajkoviKomentaraBL.deleteLajkoveKomentaraByIdKomentara(idKomentara);
        }

        public void deleteLajkoveKomentaraByIdKorisnika(long idKorisnika)
        {
            _ILajkoviKomentaraBL.deleteLajkoveKomentaraByIdKorisnika(idKorisnika);
        }

        public List<LajkoviKomentara> getAllLajkovi()
        {
            return _ILajkoviKomentaraBL.getAllLajkovi();
        }

        public long getBrojLajkovaByIdKomentara(long idKomentara)
        {
            return _ILajkoviKomentaraBL.getBrojLajkovaByIdKomentara(idKomentara);
        }

        public List<Korisnik> getKorisnikeKojiLajkujuByIdKomentara(long idKomentara)
        {
            return _ILajkoviKomentaraBL.getKorisnikeKojiLajkujuByIdKomentara(idKomentara);
        }

        public int getLajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            return _ILajkoviKomentaraBL.getLajkKomentaraByIdKorisnika(idKorisnika, idKomentara);
        }

        public List<LajkoviKomentara> getLajkoveKomenatarByKorisnikId(PrihvatanjeIdKorisnika korisnik)
        {
            return _ILajkoviKomentaraBL.getLajkovekomenatarByKorisnikId(korisnik.idKorisnika);
        }

        public List<LajkoviKomentara> getLajkoveKomentaraByIdKomentara(long idKomentara)
        {
            return _ILajkoviKomentaraBL.getLajkoveKomentaraByIdKomentara(idKomentara);
        }

        public void saveLajk(LajkoviKomentara data)
        {
            _ILajkoviKomentaraBL.saveLajk(data);
        }
    }
}
